package com.jb.udp.Enum;

public enum State {
    success (200),
    failure (201),
    loginSSO (2020),
    loginCard (2021),
    registerReapt (2030),
    deviceLost (2040);

    private int rawValue;

    State(int rawValue) {
        this.rawValue = rawValue;
    }

    public int getRawValue() {
        return rawValue;
    }
}
