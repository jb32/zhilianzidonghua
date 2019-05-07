package com.jb.udp.Interface;

import com.jb.udp.Bean.BaseResult;
import com.jb.udp.UDPData;

import java.net.InetAddress;

public interface ProResponse {
    public void answer(UDPData data, InetAddress address, int port);
    public void answer(BaseResult result);
}
