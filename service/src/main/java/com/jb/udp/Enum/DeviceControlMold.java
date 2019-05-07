package com.jb.udp.Enum;

public enum DeviceControlMold {
    m((byte) 1), s((byte) 2), d((byte) 3);

    private byte rawValue;

    DeviceControlMold(byte rawValue) {
        this.rawValue = rawValue;
    }

    public String aName() {
        return name().toUpperCase();
    }

    public static DeviceControlMold init(byte rawValue) {
        DeviceControlMold controller = null;

        for (DeviceControlMold value : DeviceControlMold.values()) {
            if (value.rawValue == rawValue) {
                controller = value;
                break;
            }
        }
        return controller;
    }
}
