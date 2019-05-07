package com.jb.udp.Bean;

import com.jb.udp.Enum.State;

public abstract class BaseResult {
    private State state;
    private String msg;

    public BaseResult(State state, String msg) {
        this.state = state;
        this.msg = msg;
    }

    public int getState() {
        return state.getRawValue();
    }

    public void setState(State state) {
        this.state = state;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return null;
    }
}
