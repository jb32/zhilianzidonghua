package com.jb.udp.Enum;

public enum DeviceMark {
    jk((byte) 1);

    private byte rawValue;

    DeviceMark(byte rawValue) {
        this.rawValue = rawValue;
    }

    public String aName() {
        return name().toUpperCase();
    }

    public static DeviceMark init(byte rawValue) {
        DeviceMark mark = null;

        for (DeviceMark value : DeviceMark.values()) {
            if (value.rawValue == rawValue) {
                mark = value;
                break;
            }
        }
        return mark;
    }
}
