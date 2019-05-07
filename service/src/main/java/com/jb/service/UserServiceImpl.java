package com.jb.service;

import com.alibaba.fastjson.JSONObject;
import com.jb.udp.Bean.BaseResult;
import com.jb.udp.Bean.ResultData;
import com.jb.udp.Command.Order;
import com.jb.udp.Command.RW;
import com.jb.udp.Command.SubOrder;
import com.jb.udp.Interface.ProResponse;
import com.jb.udp.UDPData;
import com.jb.udp.UDPManager;
import com.jb.udp.UDPReceiver;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.net.InetAddress;

@Service
public class UserServiceImpl implements UserService {
    private static Logger logger = LogManager.getLogger(UserServiceImpl.class);
    private UDPReceiver receiver;
    @Autowired
    public void setReceiver(UDPReceiver receiver) {
        this.receiver = receiver;
    }
    private UDPManager manager;
    @Autowired
    public void setManager(UDPManager manager) {
        this.manager = manager;
    }
    private volatile BaseResult baseResult;

    @Override
    public ResultData info(JSONObject jsonObject) {
        Order order = new Order(SubOrder.userInfo, RW.read);
        receiver.receiveHttp(order, jsonObject, new ProResponse() {
            @Override
            public void answer(UDPData data, InetAddress address, int port) {

            }

            @Override
            public void answer(BaseResult result) {
                baseResult = result;
            }
        });
        return (ResultData) baseResult;
    }

    @Override
    public ResultData login(JSONObject jsonObject) {
        Order order = new Order(SubOrder.login, RW.read);

        receiver.receiveHttp(order, jsonObject, new ProResponse() {
            @Override
            public void answer(UDPData data, InetAddress address, int port) {}
            @Override
            public void answer(BaseResult result) {
                baseResult = result;
            }
        });
        return (ResultData) baseResult;
    }
}
