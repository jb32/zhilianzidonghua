package com.jb.udp.Enum;

/**
 * 上棚 下棚
 */
public enum Shack {
    up(0x0),
    down(0x1);

    private int cmd;

    Shack(int cmd) {
        this.cmd = cmd;
    }

    public int getCmd() {
        return cmd;
    }

    public String des() {
        switch (this) {
            case up:
                return "up";
            case down:
                return "down";
        }
        return null;
    }

    public static Shack create(int cmd) {
        if (cmd == Shack.up.cmd) {
            return Shack.up;
        }
        return Shack.down;
    }
}
