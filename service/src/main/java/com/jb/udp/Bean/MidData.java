package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;

public class MidData<T extends BaseData> extends BaseData {
    private String msg;
    private T data;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
