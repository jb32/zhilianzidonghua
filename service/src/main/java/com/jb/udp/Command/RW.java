package com.jb.udp.Command;

public enum RW {
    read(0x0),
    write(0x40);

    private int rawValue;

    RW(int rawValue) {
        this.rawValue = rawValue;
    }

    public int getRawValue() {
        return rawValue;
    }

    static RW create(int rawValue) {
        RW rw = null;

        for (RW value : RW.values()) {
            if (value.rawValue == rawValue) {
                rw = value;
                break;
            }
        }
        return rw;
    }
}
