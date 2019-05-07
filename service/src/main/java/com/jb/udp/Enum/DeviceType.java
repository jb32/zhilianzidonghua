package com.jb.udp.Enum;

public enum DeviceType {
    mid(0),
    phone(1),
    html(2);

    private int rawValue;

    DeviceType(int rawValue) {
        this.rawValue = rawValue;
    }

    public int getRawValue() {
        return rawValue;
    }

    public void setRawValue(int rawValue) {
        this.rawValue = rawValue;
    }

    public static DeviceType create(int rawValue) {
        DeviceType type = null;

        for (DeviceType value : DeviceType.values()) {
            if (value.rawValue == rawValue) {
                type = value;
            }
        }
        return type;
    }
}
