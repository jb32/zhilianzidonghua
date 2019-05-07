package com.jb.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.jb.udp.Base.ZLError;
import com.jb.udp.Bean.BaseResult;
import com.jb.udp.Bean.MidData;
import com.jb.udp.Bean.RealTime;
import com.jb.udp.Bean.ResultData;
import com.jb.udp.Command.Order;
import com.jb.udp.Command.RW;
import com.jb.udp.Command.SubOrder;
import com.jb.udp.Enum.State;
import com.jb.udp.Interface.ProResponse;
import com.jb.udp.UDPData;
import com.jb.udp.UDPDevice;
import com.jb.udp.UDPReceiver;
import com.jb.udp.Util.JBByte;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.net.InetAddress;
import java.util.concurrent.CountDownLatch;

@Service
public class DeviceServiceImpl implements DeviceService {
    private static Logger logger = LogManager.getLogger(DeviceServiceImpl.class);

    private UDPReceiver receiver;
    @Autowired
    public void setReceiver(UDPReceiver receiver) {
        this.receiver = receiver;
    }
    private volatile BaseResult baseResult;

    @Override
    public BaseResult devices(JSONObject data) {
        Order order = new Order(SubOrder.devices, RW.read);
        receiver.receiveHttp(order, data, new ProResponse() {
            @Override
            public void answer(UDPData data, InetAddress address, int port) {

            }

            @Override
            public void answer(BaseResult reuslt) {
                baseResult = reuslt;
            }
        });
        return baseResult;
    }

    @Override
    public BaseResult realTime(final JSONObject data) {
        final ResultData[] resultData = new ResultData[1];
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        Order order = new Order(SubOrder.realTime, RW.read);

        receiver.receiveHttp(order, data, new ProResponse() {
            @Override
            public void answer(UDPData udpData, InetAddress address, int port) {
                try {
                    UDPDevice device = new UDPDevice(JBByte.toList(udpData.getRawData()));
                    JSONObject deviceData = device.getData();
                    MidData<RealTime> realTimeMidData = JSON.parseObject(deviceData.toJSONString(), new TypeReference<MidData<RealTime>>() {});
                    resultData[0] = new ResultData(State.success, "", realTimeMidData);
                    countDownLatch.countDown();
                } catch (ZLError zlError) {
                    logger.log(Level.ERROR, zlError.getMessage());
                }
            }

            @Override
            public void answer(BaseResult baseResult) {

            }
        });
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            logger.log(Level.ERROR, e.getMessage());
        }
        return resultData[0];
    }
}
