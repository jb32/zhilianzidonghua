package com.jb.udp.Enum;

import com.jb.udp.Util.JBByte;

public class DeviceMold {
    private long rawValue;

    public DeviceMold(long rawValue) {
        this.rawValue = rawValue;
    }
    /// 改进代码
    private String improve() {
        byte num = (byte) (rawValue & 0xF);
        return num + "";
    }
    /// 细分类型
    private String subdivide() {
        byte num = (byte) ((rawValue >> 4) & 0xF);
        return JBByte.toXvHao(num);
    }
    /// 显示方式
    private String display() {
        byte num = (byte) ((rawValue >> 8) & 0x3F);
        return JBByte.toRoman(num);
    }
    /// 控制器类型
    private String controller() {
        byte num = (byte) ((rawValue >> 14) & 0x3F);
        DeviceControlMold ct = DeviceControlMold.init(num);

        if (ct == null) {
            return "";
        }
        return ct.aName();
    }
    /// 烤房控制器代号
    private String mark() {
        byte num = (byte) ((rawValue >> 24) & 0xFF);
        DeviceMark mk = DeviceMark.init(num);

        if (mk == null) {
            return "";
        }
        return mk.aName();
    }

    public String[] arr() {
        String[] strings = new String[7];
        strings[0] = mark();
        strings[1] = controller();
        strings[2] = "-";
        strings[3] = display();
        strings[4] = subdivide();
        strings[5] = "/";
        strings[6] = improve();
        return strings;
    }
}
