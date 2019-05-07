package com.jb.udp.Base;

import com.jb.udp.Enum.State;

public class ZLError extends Exception {
    private State state;

    public ZLError(State state, String message) {
        super(message);
        this.state = state;
    }

    public State getState() {
        return state;
    }
}
