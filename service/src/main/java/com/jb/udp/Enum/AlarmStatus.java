package com.jb.udp.Enum;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

public enum AlarmStatus {
    /// Bit7     温度传感器故障
    dry((byte) (0x80)),
    /// Bit6     湿度传感器故障
    wet((byte) (0x40)),
    /// Bit5     循环风机缺相
    phase((byte) 0x20),
    /// Bit4     循环风机过载
    fanOver((byte) 0x10),
    /// Bit3     电压超高限
    voltageHigh((byte) 0x08),
    /// Bit2     电压超低限
    voltageLow((byte) 0x04),
    /// Bit1     温度偏温
    dryHigh((byte) 0x02),
    /// Bit0     湿度偏温
    wetHigh((byte) 0x01);

    byte rawValue;

    AlarmStatus(byte rawValue) {
        this.rawValue = rawValue;
    }

    public static EnumSet<AlarmStatus> get(Integer rawValue) {
        EnumSet<AlarmStatus> enumSet = EnumSet.noneOf(AlarmStatus.class);

        for (AlarmStatus status : AlarmStatus.values()) {
            if ((rawValue & status.rawValue) == status.rawValue) {
                enumSet.add(status);
            }
        }
        return enumSet;
    }

    public static List<String> parse(EnumSet<AlarmStatus> statuses) {
        List<String> d = new ArrayList<>();

        if (statuses.contains(dry)) {
            d.add("温度传感器故障");
        }

        if (statuses.contains(wet)) {
            d.add("湿度传感器故障");
        }

        if (statuses.contains(phase)) {
            d.add("循环风机缺相");
        }

        if (statuses.contains(fanOver)) {
            d.add("循环风机过载");
        }

        if (statuses.contains(voltageHigh)) {
            d.add("电压超高限");
        }

        if (statuses.contains(voltageLow)) {
            d.add("电压超低限");
        }

        if (statuses.contains(dryHigh)) {
            d.add("温度偏温");
        }

        if (statuses.contains(wetHigh)) {
            d.add("湿度偏温");
        }

        return d;
    }
}
