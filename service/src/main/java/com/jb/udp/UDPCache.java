package com.jb.udp;

import java.util.Date;

final public class UDPCache {
    private Date date;
    private byte[] response;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public byte[] getResponse() {
        return response;
    }

    public void setResponse(byte[] response) {
        this.response = response;
    }
}
