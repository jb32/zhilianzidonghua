package com.jb.udp.Net;

import com.jb.udp.Interface.ProResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

final public class UDPSession {
    private static Logger logger = LogManager.getLogger(UDPSession.class);

    private UDPConnect sender;
    private UDPConnect receiver;
    private ProResponse proResponse;

    public UDPSession() { }

    public void setSender(UDPConnect sender) {
        this.sender = sender;
    }

    public UDPConnect getSender() {
        return sender;
    }

    public UDPConnect getReceiver() {
        return receiver;
    }

    public void setReceiver(UDPConnect receiver) {
        this.receiver = receiver;
    }

    public void setProResponse(ProResponse proResponse) {
        this.proResponse = proResponse;
    }

    public ProResponse getProResponse() {
        return proResponse;
    }

}
