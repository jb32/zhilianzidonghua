package com.jb.udp.Command;

public enum SubOrder {

    /// 命令码=0x00(R),读取分机设备类型、协议版本、软件版本
    status(0x0),
    /// 命令码=0x01(R),读取分机实时数据
    realTime(0x1),
    /// 命令码=0x02(RW),读写分机整条曲线数据
    curves(0x2),
    /// 命令码=0x03(RW),读写分机曲线段数据
    curve(0x3),
    /// 命令码=0x04(W),分机运行/停止控制
    run(0x4),
    /// 命令码=0x05(W),选择分机烘烤曲线
    curveCoding(0x5),
    /// 命令码=0x06(W),设置分机运行段
    curveNum(0x6),
    /// 命令码=0x07(W),设置分机上/下棚
    shed(0x7),
    /// 命令码=0x08(RW),读写分机烤次及日期时间
    time(0x8),
    /// 命令码=0x09(R),读取分机记录数据
    record(0x9),
    /// 命令码=0x0A(W)，远程绑定与解绑命令
    bind(0xA),
    /// 命令码=0x10(R),读取分机生物质燃烧机状态
    burner_status(0x10),
    /// 命令码=0x12(W),生物质燃烧机点火
    burner_fire(0x11),
    /// 命令码=0x13(W),生物质燃烧机跳过点火
    burner_pass_fire(0x12),
    /// 命令码=0x14(W),生物质燃烧机关机命令
    burner_off(0x13),
    /// 心跳
    bindDevice(0xF7),
    /// 编辑设备
    editDevice(0xF8),
    /// 设备列表
    devices(0xF9),
    /// 删除设备
    deleteDevice(0xFA),
    /// 添加设备
    addDevice(0xFB),
    /// 用户信息
    userInfo(0xFC),
    /// 修改密码
    password(0xFD),
    /// 登录
    login(0xFE),
    /// 注册命令
    register(0xFF);

    private int rawValue;

    SubOrder(int rawValue) {
        this.rawValue = rawValue;
    }

    public int getRawValue() {
        return rawValue;
    }

    public static SubOrder create(int rawValue) {
        SubOrder[] values = SubOrder.values();
        SubOrder subOrder = null;

        for (SubOrder value : values) {
            if (value.rawValue == rawValue) {
                subOrder = value;
            }
        }
        return subOrder;
    }
}
