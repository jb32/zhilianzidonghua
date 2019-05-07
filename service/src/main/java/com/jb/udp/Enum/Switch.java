package com.jb.udp.Enum;

/**
 * 开关
 */
public enum Switch {
    on(0x1),
    off(0x0);

    public byte getCmd() {
        return cmd;
    }

    private byte cmd;

    Switch(int isOn) {
        this.cmd = (byte) isOn;
    }
}
