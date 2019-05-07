package com.jb.udp;

import com.alibaba.fastjson.JSONObject;
import com.jb.udp.Command.Order;
import com.jb.udp.Interface.ProResponse;
import com.jb.udp.Net.UDPConnect;
import com.jb.udp.Net.UDPSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

final public class UDPReceiver {
    private static Logger logger = LogManager.getLogger(UDPReceiver.class);
    private Map<String, UDPSession> sessionMap = new HashMap<>();
    private ExecutorService executorService = Executors.newSingleThreadExecutor();

    private UDPManager udpManager;
    @Autowired
    public void setUdpManager(UDPManager udpManager) {
        this.udpManager = udpManager;
    }

    private ObjectFactory<UDPData> factory;
    @Autowired
    public void setFactory(ObjectFactory<UDPData> factory) {
        this.factory = factory;
    }

    private UDPCaches udpCaches;
    @Autowired
    public void setUdpCaches(UDPCaches udpCaches) {
        this.udpCaches = udpCaches;
    }

    private UDPReceiver() {}

    public void receiveUdp(byte[] contents, InetAddress fromAddress, int formPort, ProResponse proResponse) {

        UDPData udpData = factory.getObject();
        udpData.decompose(contents).nextCompose();
        /*记录设备*/
        udpData.addDevice(fromAddress, formPort);

        UDPConnect connect = new UDPConnect(fromAddress, formPort);
        connect.setResponseData(udpData.getTargetData());

        UDPSession session;

        if (udpData.isOwn()) {
            session = sessionMap.get(udpData.getFromIdentifier());

            if (session == null) {
                session = new UDPSession();
                session.setProResponse(proResponse);
                sessionMap.put(udpData.getFromIdentifier(), session);
                logger.info("加入会话，会话识别码：" + udpData.getFromIdentifier() + " " + sessionMap.size() + " " + this);
            }
            session.setSender(connect);
            session.setReceiver(connect);
        } else {
            session = sessionMap.get(udpData.getUid() + udpData.getMid());

            if (session == null) {
                session = new UDPSession();
                session.setProResponse(proResponse);
                sessionMap.put(udpData.getUid() + udpData.getMid(), session);
            }
            if (udpData.isPhoneToDevice()) {
                session.setSender(connect);
            } else if (udpData.isDeviceToPhone()){
                session.setReceiver(connect);
            }
        }
        /*获取目标回话，从而获取目标地址*/
        UDPSession toSession = sessionMap.get(udpData.getToIdentifier());

        if (toSession != null) {
            /*配置目标地址*/
            connect.setToAddress(toSession.getSender().getFromAddress());
            connect.setToPort(toSession.getSender().getFromPort());
        }
        session.getProResponse().answer(udpData, connect.getToAddress(), connect.getToPort());
    }

    public void receiveHttp(final Order order, JSONObject data, final ProResponse proResponse) {
        UDPData udpData = factory.getObject();
        udpData.decompose(data, order).nextCompose();

        UDPConnect connect = new UDPConnect();
        UDPSession toSession = sessionMap.get(udpData.getToIdentifier());

        if (toSession != null) {
            connect.setToAddress(toSession.getSender().getToAddress());
            connect.setToPort(toSession.getSender().getToPort());
        }
        UDPSession session = sessionMap.get(udpData.getUid() + udpData.getMid());

        if (session == null) {
            session = new UDPSession();
            sessionMap.put(udpData.getUid() + udpData.getMid(), session);
        }
        session.setProResponse(proResponse);
        if (order.isService()) {
            session.getProResponse().answer(udpData.getBaseResult());
        } else {
            try {
                udpManager.send(udpData.getTargetData(), connect.getToAddress(), connect.getToPort());
            } catch (IOException e) {
                logger.info(e.getMessage());
            }
        }
    }

    public Boolean isOnline(String mid) {
        UDPSession session = sessionMap.get(mid);
//        StringBuffer buffer1 = new StringBuffer(mid);
//
//        for (String s : sessionMap.keySet()) {
//            StringBuffer buffer = new StringBuffer(s);
//
//            for (int i = 0; i < buffer.capacity(); i++) {
//                if (buffer.charAt(i) == buffer1.charAt(i)) {
//                    logger.info(buffer.charAt(i));
//                } else {
//                    logger.info(buffer.charAt(i) + "!=" + buffer1.charAt(i));
//                    break;
//                }
//            }
//        }

        if (session == null) {
            logger.info("会话不存在：" + mid + " " + sessionMap.size() + " " + this);
            return false;
        }

        if (session.getSender().isTimeout()) {
            logger.info("会话超时：" + mid + " " + sessionMap.size() + " " + this);
            sessionMap.remove(mid);
            return false;
        }
        return true;
    }
}
