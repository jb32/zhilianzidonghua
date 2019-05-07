package com.jb.udp.Net;

import com.jb.udp.Bean.BaseResult;

import java.net.InetAddress;
import java.util.Date;

final public class UDPConnect {
    private Date createDate;
    private InetAddress fromAddress;
    private int fromPort;
    private InetAddress toAddress;
    private int toPort;

    private byte[] responseData;
    private BaseResult baseResult;

    public UDPConnect(InetAddress fromAddress, int fromPort) {
        this.createDate = new Date();
        this.fromAddress = fromAddress;
        this.fromPort = fromPort;
    }

    public UDPConnect() {}

    public void setResponseData(byte[] responseData) {
        this.responseData = responseData;
    }

    public BaseResult getBaseResult() {
        return baseResult;
    }

    public InetAddress getFromAddress() {
        return fromAddress;
    }

    public UDPConnect setFromAddress(InetAddress fromAddress) {
        this.fromAddress = fromAddress;
        return this;
    }

    public int getFromPort() {
        return fromPort;
    }

    public void setFromPort(int fromPort) {
        this.fromPort = fromPort;
    }

    public void setToAddress(InetAddress toAddress) {
        this.toAddress = toAddress;
    }

    public InetAddress getToAddress() {
        return toAddress;
    }

    public void setToPort(int toPort) {
        this.toPort = toPort;
    }

    public int getToPort() {
        return toPort;
    }

    public boolean isTimeout() {
        Date now = new Date();
        return now.getTime() - createDate.getTime() > 300000;
    }
}
