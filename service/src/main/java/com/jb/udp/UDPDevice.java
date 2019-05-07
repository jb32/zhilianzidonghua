package com.jb.udp;

import com.alibaba.fastjson.JSONObject;
import com.jb.udp.Base.ZLError;
import com.jb.udp.Command.Order;
import com.jb.udp.Enum.*;
import com.jb.udp.Util.JBByte;
import com.jb.udp.Util.JBString;

import java.util.*;

final public class UDPDevice {
    private JSONObject data;

    public JSONObject getData() {
        return data;
    }

    private Byte rspCode;
    private Order order;
    private boolean alarm;
    private String alarmDes;

    public UDPDevice(List<Byte> bytes) throws ZLError {
        List<Byte> checks = bytes.subList(0, bytes.size() - 1);
        Integer sum = 0;

        for (Byte aByte : checks) {
            sum += aByte.intValue() & 0xFF;
        }

        Byte orderValue = bytes.remove(0);/// 命令码
        rspCode = bytes.remove(0); /// 应答码
        order = new Order(orderValue.intValue());

        Integer check;

        if ((rspCode & 0x80) == 0x80) {
            /// 应答数据长度
            List<Byte> subList = bytes.subList(0, 4);
            int length = (int) UDPIterator.parse(JBByte.bytes(subList));
            subList.clear();
            /// 校验码
            List<Byte> subList1 = bytes.subList(bytes.size() - 5, bytes.size() - 1);
            check = (Integer) UDPIterator.parse(JBByte.bytes(subList1));
            subList1.clear();
            /// 长度校验
            if (bytes.size() != length) {
                throw new ZLError(State.failure, "长度校验错误");
            }
        } else {
            if (bytes.size() < 1) {
                throw new ZLError(State.failure, "数据错误");
            }
            int length = bytes.remove(0).intValue() & 0xFF;

            if (bytes.size() < 1) {
                throw new ZLError(State.failure, "数据错误");
            }
            check = bytes.remove(bytes.size() - 1).intValue();

            if (bytes.size() != length) {
                throw new ZLError(State.failure, "长度校验错误");
            }
        }
        sum += check;
        sum &= 0xFF;

        if (sum.byteValue() != 0) {
            throw new ZLError(State.failure, "和校验错误");
        }
        JSONObject data = decode(JBByte.bytes(bytes));

        data.put("rspCode", rspCode);

        JSONObject rsp = new JSONObject();
        rsp.put("data", data);
        rsp.put("msg", "");

        this.data = rsp;
    }

    // TODO: - 解码
    private JSONObject decode(byte[] bytes) {
        JSONObject jsonObject;

        switch (order.getSub()) {

            case status:
                jsonObject = decodeStatus(bytes);
                break;
            case realTime:
                jsonObject = decodeRealTime(bytes);
                break;
            case curves:
                jsonObject = decodeCurves(bytes);
                break;
            case curve:
                jsonObject = decodeCurve(bytes);
                break;
            case run:
                jsonObject = decodeRun(bytes);
                break;
            case curveCoding:
                jsonObject = decodeCurveCoding(bytes);
                break;
            case curveNum:
                jsonObject = decodeCurveNum(bytes);
                break;
            case shed:
                jsonObject = decodeShed(bytes);
                break;
            case time:
                jsonObject = decodeTime(bytes);
                break;
            case record:
                jsonObject = decodeRecord(bytes);
                break;
            case burner_status:
                jsonObject = decodeBurner_status(bytes);
                break;
            case burner_fire:
                jsonObject = decodeBurner_fire(bytes);
                break;
            case burner_pass_fire:
                jsonObject = decodeBurner_pass_fire(bytes);
                break;
            case burner_off:
                jsonObject = decodeBurner_off(bytes);
                break;
            default:
                jsonObject = new JSONObject();
                break;
        }
        return jsonObject;
    }

    /*命令码=0x00(R),读取分机设备类型、协议版本、软件版本*/
    private JSONObject decodeStatus(byte[] bytes) {
        JSONObject json = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);

        long type = (long) decoder.iterator(4);
        DeviceMold deviceType = new DeviceMold(type);
        json.put("type", deviceType.arr());

        byte treaty0 = (byte) decoder.iterator(1);
        byte treaty1 = (byte) decoder.iterator(1);
        String treaty = "V" + Integer.toHexString(treaty0) + "." + Integer.toHexString(treaty1);
        json.put("treatyVersions", treaty);

        byte version0 = (byte) decoder.iterator(1);
        byte version1 = (byte) decoder.iterator(1);
        String versions = "V" + Integer.toHexString(version0) + "." + Integer.toHexString(version1);
        json.put("versions", versions);

        return json;
    }

    /*命令码=0x01(R),读取分机实时数据*/
    private JSONObject decodeRealTime(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);

        byte status0 = (byte) decoder.iterator(1);
        jsonObject.put("curveNum", status0 & 0x1F);

        byte status1 = (byte) decoder.iterator(1);
        jsonObject.put("coding", status1 & 0x0F);
        jsonObject.put("run", (status1 & 0x10) >> 4);
        jsonObject.put("shed", (status1 & 0x20) >> 5);
        jsonObject.put("subAlarm", (status1 & 0x40) >> 6);

        Integer dryT = (Integer) decoder.iterator(2);
        Integer wetT = (Integer) decoder.iterator(2);

        jsonObject.put("dryT", dryT.floatValue() / 100.0);
        jsonObject.put("wetT", wetT.floatValue() / 100.0);

        int hour = (byte) decoder.iterator(1) & 0xFF;
        int miunte = (byte) decoder.iterator(1) & 0xFF;
        jsonObject.put("time", hour + "h " + miunte + "m");

        int hourT = (byte) decoder.iterator(1) & 0xFF;
        int miunteT = (byte) decoder.iterator(1) & 0xFF;
        jsonObject.put("timeTotal", hourT + "h " + miunteT + "m");

        Integer dryAim = (Integer) decoder.iterator(2);
        jsonObject.put("dryAim", dryAim.floatValue() / 100.0);

        Integer wetAim = (Integer) decoder.iterator(2);
        jsonObject.put("wetAim", wetAim.floatValue() / 100.0);

        Integer voltage = (Integer) decoder.iterator(2);
        jsonObject.put("voltage", voltage.floatValue());

        byte status = (byte) decoder.iterator(1);
        EnumSet<PerformStatus> performStatuses = PerformStatus.getSet(status);
        jsonObject.put("isAlarm", performStatuses.contains(PerformStatus.alarm));

        List<String> voltageStatus = new ArrayList<>();

        if (performStatuses.contains(PerformStatus.voltageProtect)) {
            voltageStatus.add("电压超限保护");
        }

        if (performStatuses.contains(PerformStatus.voltageWobble)) {
            voltageStatus.add("电压闪烁");
        }
        jsonObject.put("voltageStatus", voltageStatus);
        jsonObject.put("isFanOn", performStatuses.contains(PerformStatus.fanOn));
        jsonObject.put("fan", performStatuses.contains(PerformStatus.fanHight) ? "高" : (performStatuses.contains(PerformStatus.fanLow) ? "低" : ""));
        jsonObject.put("warm", performStatuses.contains(PerformStatus.warm));
        jsonObject.put("intakeOn", performStatuses.contains(PerformStatus.intakeOn));

        byte alarm = (byte) decoder.iterator(1);
        EnumSet<AlarmStatus> alarmStatuses = AlarmStatus.get((int) alarm);
        List<String> parse = AlarmStatus.parse(alarmStatuses);
        jsonObject.put("alarmStatus", parse);
        this.alarm = parse.size() > 0;
        alarmDes = JBString.join(",", parse);

        Integer dryTHelp = (Integer) decoder.iterator(2);
        Integer wetTHelp = (Integer) decoder.iterator(2);

        jsonObject.put("dryTHelp", dryTHelp.floatValue() / 100);
        jsonObject.put("wetTHelp", wetTHelp.floatValue() / 100);

        Map<String, Object> curve = new HashMap<>();
        byte dry = (byte) decoder.iterator(1);
        curve.put("dry", dry);

        byte wet = (byte) decoder.iterator(1);
        float wetd = ((wet >> 7) & 0x1) == 0 ? 0 : (float) 0.5;
        float wetF = (wet & 0x7F) + wetd;
        curve.put("wet", wetF);

        byte up = (byte) decoder.iterator(1);
        curve.put("up", up);

        byte steady = (byte) decoder.iterator(1);
        curve.put("steady", steady);

        jsonObject.put("currentCurve", curve);

        return jsonObject;
    }

    /*命令码=0x02(RW)，读写分机整条曲线数据*/
    private JSONObject decodeCurves(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte curve = (byte) decoder.iterator(1);
        jsonObject.put("coding", curve & 0x0F);

        List<Map<String, Float>> curves = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            Map<String, Float> _curve = new HashMap<>();
            _curve.put("dry", (float) (byte) decoder.iterator(1));
            byte wet = (byte) decoder.iterator(1);
            _curve.put("wet", (float) ((wet & 0x7F) + ((wet & 0x80) == 0x80 ? 0.5 : 0.0)));
            _curve.put("up", (float) (byte) decoder.iterator(1));
            _curve.put("steady", (float) (byte) decoder.iterator(1));
            decoder.iterator(2);
            curves.add(_curve);
        }
        jsonObject.put("curves", curves);

        return jsonObject;
    }

    /*命令码=0x03(RW)，读写分机曲线段数据*/
    private JSONObject decodeCurve(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte curve = (byte) decoder.iterator(1);
        jsonObject.put("coding", curve & 0x0F);
        jsonObject.put("curveNum", decoder.iterator(1));

        Map<String, Float> _curve = new HashMap<>();
        byte dry = (byte) decoder.iterator(1);
        _curve.put("dry", (float) dry);

        byte wet = (byte) decoder.iterator(1);
        _curve.put("wet", (float) ((wet & 0x7F) + ((wet & 0x80) == 0x80 ? 0.5 : 0.0)));

        byte up = (byte) decoder.iterator(1);
        _curve.put("up", (float) up);

        byte steady = (byte) decoder.iterator(1);
        _curve.put("steady", (float) steady);

        jsonObject.put("curve", _curve);

        return jsonObject;
    }

    /*命令码=0x04(W)，分机运行/停止控制*/
    private JSONObject decodeRun(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte run = (byte) decoder.iterator(1);
        jsonObject.put("isRun", run);
        return jsonObject;
    }

    /*命令码=0x05(W)，选择分机烘烤曲线*/
    private JSONObject decodeCurveCoding(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte run = (byte) decoder.iterator(1);
        jsonObject.put("coding", run);
        return jsonObject;
    }

    /*命令码=0x06(W)，设置分机运行段*/
    private JSONObject decodeCurveNum(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte curveNum = (byte) decoder.iterator(1);
        jsonObject.put("curveNum", curveNum);
        return jsonObject;
    }

    /*命令码=0x07(W)，设置分机上/下棚*/
    private JSONObject decodeShed(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte shed = (byte) decoder.iterator(1);
        jsonObject.put("shed", shed);
        return jsonObject;
    }

    /*命令码=0x08(RW)，读写分机烤次及日期时间*/
    private JSONObject decodeTime(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte bakeTimes = (byte) decoder.iterator(1);
        jsonObject.put("bakeTimes", bakeTimes & 0x0F);
        jsonObject.put("year", decoder.iterator(1));
        jsonObject.put("month", decoder.iterator(1));
        jsonObject.put("day", decoder.iterator(1));
        jsonObject.put("hour", decoder.iterator(1));
        jsonObject.put("minute", decoder.iterator(1));
        return jsonObject;
    }

    /*命令码=0x09(R)，读取分机记录数据*/
    private JSONObject decodeRecord(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);

        byte bakeTimes = (byte) decoder.iterator(1);
        jsonObject.put("bakeTimes", bakeTimes);

        Integer totalTimes = (Integer) decoder.iterator(2);
        jsonObject.put("totalTimes", totalTimes);

        Integer record = (Integer) decoder.iterator(2);
        jsonObject.put("record", record);

        if (totalTimes <= 0) {
            return jsonObject;
        }

        byte record0 = (byte) decoder.iterator(1);
        jsonObject.put("month", (record0 >> 4) & 0xFF);
        jsonObject.put("times", record0 & 0x0F);

        Integer record1 = (Integer) decoder.iterator(2);
        jsonObject.put("dry", (float) (record1 >> 6) / 10.0);

        byte year = (byte) (record1 & 0x3F);

        Integer record2 = (Integer) decoder.iterator(2);
        jsonObject.put("wet", (float) (record2 >> 6) / 10.0);
        year = (byte) (year | (record2 & 0x20));
        jsonObject.put("year", year & 0xFF);
        jsonObject.put("day", record2 & 0x1F);

        Integer record3 = (Integer) decoder.iterator(2);
        jsonObject.put("dryAim", (float) (record3 >> 6) / 10.0);
        jsonObject.put("hour", record3 & 0x3F);

        Integer record4 = (Integer) decoder.iterator(2);
        jsonObject.put("wetAim", (float) (record4 >> 6) / 10.0);
        jsonObject.put("minute", record4 & 0x3F);

        byte total = (byte) decoder.iterator(1);
        jsonObject.put("total", total & 0xFF);

        byte record4_0 = (byte) decoder.iterator(1);
        jsonObject.put("shed", (record4_0 >> 7) & 0xFF);
        jsonObject.put("tStatus", record4_0 & 0x1);

        EnumSet<RecordEvent> recordEvents = RecordEvent.get(record4_0);
        ArrayList<String> des = RecordEvent.des(recordEvents);
        jsonObject.put("events", des);

        byte record5 = (byte) decoder.iterator(1);
        jsonObject.put("type", record5 & 0xF);

        return jsonObject;
    }

    // TODO: - 命令码=0x10(R)，读取分机生物质燃烧机状态
    /*命令码=0x10(R)，读取分机生物质燃烧机状态*/
    private JSONObject decodeBurner_status(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        byte status = (byte) decoder.iterator(1);
        jsonObject.put("status", status);
        byte alarm = (byte) decoder.iterator(1);
        jsonObject.put("alarm", BurnerAlarm.des(BurnerAlarm.get(alarm)));
        jsonObject.put("fire", decoder.iterator(1));
        jsonObject.put("times", decoder.iterator(1));
        jsonObject.put("thermocouple", decoder.iterator(2));
        return jsonObject;
    }

    /*命令码=0x11(W),生物质燃烧机点火*/
    private JSONObject decodeBurner_fire(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        jsonObject.put("status", decoder.iterator(1));
        return jsonObject;
    }

    /*命令码=0x12(W),生物质燃烧机跳过点火*/
    private JSONObject decodeBurner_pass_fire(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        jsonObject.put("status", decoder.iterator(1));
        return jsonObject;
    }

    /*命令码=0x13(W),生物质燃烧机关机命令*/
    private JSONObject decodeBurner_off(byte[] bytes) {
        JSONObject jsonObject = new JSONObject();
        UDPIterator decoder = new UDPIterator(bytes);
        jsonObject.put("status", decoder.iterator(1));
        return jsonObject;
    }
}
