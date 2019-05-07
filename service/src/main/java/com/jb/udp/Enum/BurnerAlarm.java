package com.jb.udp.Enum;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

public enum BurnerAlarm {
    /// Bit2     热电偶故障
    thermocouple((byte)0x04),
    /// Bit1     旋转电机故障
    rotateFan((byte) 0x02),
    /// Bit0     进料电机故障
    feedFan((byte) 0x01);

    byte rawValue;

    BurnerAlarm(byte rawValue) {
        this.rawValue = rawValue;
    }

    public static EnumSet<BurnerAlarm> get(byte rawValue) {
        EnumSet<BurnerAlarm> enumSet = EnumSet.noneOf(BurnerAlarm.class);

        for (BurnerAlarm status : BurnerAlarm.values()) {
            if ((rawValue & status.rawValue) == status.rawValue) {
                enumSet.add(status);
            }
        }
        return enumSet;
    }

    public static List<String> des(EnumSet<BurnerAlarm> statuses) {
        List<String> d = new ArrayList<>();

        if (statuses.contains(thermocouple)) {
            d.add("热电偶故障");
        }
        if (statuses.contains(rotateFan)) {
            d.add("旋转电机故障");
        }
        if (statuses.contains(feedFan)) {
            d.add("进料电机故障");
        }
        return d;
    }
}
