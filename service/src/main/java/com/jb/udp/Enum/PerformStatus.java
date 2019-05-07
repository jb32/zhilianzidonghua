package com.jb.udp.Enum;

import java.util.EnumSet;

public enum PerformStatus {
    /// Bit7     1表示允许报警
    alarm((byte) 0x80),
    /// Bit6     1表示电压超限保护
    voltageProtect((byte) 0x40),
    /// Bit5     1表示电压闪烁
    voltageWobble((byte) 0x20),
    /// Bit4     1表示循环风机开启
    fanOn((byte) 0x10),
    /// Bit3     1表示循环风机高速
    fanHight((byte) 0x08),
    /// Bit2     1表示循环风机低速
    fanLow((byte) 0x04),
    /// Bit1     1表示加热开启
    warm((byte) 0x02),
    /// Bit0     1表示进风门开启
    intakeOn((byte) 0x01);

    byte rawValue;

    PerformStatus(byte rawValue) {
        this.rawValue = rawValue;
    }

    public static EnumSet<PerformStatus> getSet(byte rawValue) {
        EnumSet<PerformStatus> enumSet = EnumSet.noneOf(PerformStatus.class);

        for (PerformStatus status : PerformStatus.values()) {
            if ((rawValue & status.rawValue) == status.rawValue) {
                enumSet.add(status);
            }
        }
        return enumSet;
    }
}
