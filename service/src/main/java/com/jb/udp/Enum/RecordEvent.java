package com.jb.udp.Enum;

import java.util.ArrayList;
import java.util.EnumSet;

public enum RecordEvent {
    sensor((byte)(0x1 << 6)),
    phase((byte)(0x1 << 5)),
    over((byte)(0x1 << 4)),
    powerOutage((byte)(0x1 << 3)),
    dryOver((byte)(0x1 << 2)),
    wetOver((byte)(0x1 << 1));

    private byte rawValue;

    RecordEvent(byte rawValue) {
        this.rawValue = rawValue;
    }

    public static EnumSet<RecordEvent> get(byte rawValue) {
        EnumSet<RecordEvent> enumSet = EnumSet.noneOf(RecordEvent.class);

        for (RecordEvent status : RecordEvent.values()) {
            if ((rawValue & status.rawValue) == status.rawValue) {
                enumSet.add(status);
            }
        }
        return enumSet;
    }

    public static ArrayList<String> des(EnumSet<RecordEvent> enumSet) {
        ArrayList<String> arr = new ArrayList<>();

        if (enumSet.contains(sensor)) {
            arr.add("传感器故障");
        }

        if (enumSet.contains(phase)) {
            arr.add("缺相");
        }

        if (enumSet.contains(over)) {
            arr.add("过载");
        }

        if (enumSet.contains(powerOutage)) {
            arr.add("停电");
        }

        if (enumSet.contains(dryOver)) {
            arr.add("温度超限");
        }

        if (enumSet.contains(wetOver)) {
            arr.add("湿度超限");
        }

        return arr;
    }
}
