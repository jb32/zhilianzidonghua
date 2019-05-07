package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;
//{"msg":"","data":
// {"shed":1,"timeTotal":"2h 0m","dryT":18.5,"run":0,"wetAim":38.0,"voltageStatus":[],
// "voltage":231.0,"intakeOn":false,"subAlarm":1,"coding":2,"fan":"低","warm":true,
// "alarmStatus":["温度偏温","湿度偏温"],"dryTHelp":18.31,"rspCode":0,"curveNum":10,
// "isAlarm":false,"currentCurve":{"wet":38.0,"dry":44,"up":5,"steady":1},
// "wetT":18.56,"dryAim":42.1,"wetTHelp":18.5,"time":"0h 0m","isFanOn":false}}
public class RealTime extends BaseData {
    private Integer shed;
    private String timeTotal;
    private Float dryT;
    private Integer run;
    private Float wetAim;
    private String[] voltageStatus;
    private Float voltage;
    private Boolean intakeOn;
    private Integer subAlarm;
    private Integer coding;
    private String fan;
    private Boolean warm;
    private String[] alarmStatus;
    private Float dryTHelp;
    private Byte rspCode;
    private Integer curveNum;
    private Boolean isAlarm;
    private Curve currentCurve;
    private Float wetT;
    private Float dryAim;
    private Float wetTHelp;
    private String time;
    private Boolean isFanOn;

    public Integer getCurveNum() {
        return curveNum;
    }

    public void setCurveNum(Integer curveNum) {
        this.curveNum = curveNum;
    }

    public Integer getCoding() {
        return coding;
    }

    public void setCoding(Integer coding) {
        this.coding = coding;
    }

    public Integer getRun() {
        return run;
    }

    public void setRun(Integer run) {
        this.run = run;
    }

    public Integer getShed() {
        return shed;
    }

    public void setShed(Integer shed) {
        this.shed = shed;
    }

    public Integer getSubAlarm() {
        return subAlarm;
    }

    public void setSubAlarm(Integer subAlarm) {
        this.subAlarm = subAlarm;
    }

    public Float getDryT() {
        return dryT;
    }

    public void setDryT(Float dryT) {
        this.dryT = dryT;
    }

    public Float getWetT() {
        return wetT;
    }

    public void setWetT(Float wetT) {
        this.wetT = wetT;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getTimeTotal() {
        return timeTotal;
    }

    public void setTimeTotal(String timeTotal) {
        this.timeTotal = timeTotal;
    }

    public Float getDryAim() {
        return dryAim;
    }

    public void setDryAim(Float dryAim) {
        this.dryAim = dryAim;
    }

    public Float getWetAim() {
        return wetAim;
    }

    public void setWetAim(Float wetAim) {
        this.wetAim = wetAim;
    }

    public Float getVoltage() {
        return voltage;
    }

    public void setVoltage(Float voltage) {
        this.voltage = voltage;
    }

    public Boolean getAlarm() {
        return isAlarm;
    }

    public void setAlarm(Boolean alarm) {
        isAlarm = alarm;
    }

    public String[] getVoltageStatus() {
        return voltageStatus;
    }

    public void setVoltageStatus(String[] voltageStatus) {
        this.voltageStatus = voltageStatus;
    }

    public Boolean getFanOn() {
        return isFanOn;
    }

    public void setFanOn(Boolean fanOn) {
        isFanOn = fanOn;
    }

    public String getFan() {
        return fan;
    }

    public void setFan(String fan) {
        this.fan = fan;
    }

    public Boolean getWarm() {
        return warm;
    }

    public void setWarm(Boolean warm) {
        this.warm = warm;
    }

    public Boolean getIntakeOn() {
        return intakeOn;
    }

    public void setIntakeOn(Boolean intakeOn) {
        this.intakeOn = intakeOn;
    }

    public String[] getAlarmStatus() {
        return alarmStatus;
    }

    public void setAlarmStatus(String[] alarmStatus) {
        this.alarmStatus = alarmStatus;
    }

    public Float getDryTHelp() {
        return dryTHelp;
    }

    public void setDryTHelp(Float dryTHelp) {
        this.dryTHelp = dryTHelp;
    }

    public Float getWetTHelp() {
        return wetTHelp;
    }

    public void setWetTHelp(Float wetTHelp) {
        this.wetTHelp = wetTHelp;
    }

    public Curve getCurrentCurve() {
        return currentCurve;
    }

    public void setCurrentCurve(Curve currentCurve) {
        this.currentCurve = currentCurve;
    }

    public Byte getRspCode() {
        return rspCode;
    }

    public void setRspCode(Byte rspCode) {
        this.rspCode = rspCode;
    }

    class Curve {
        Byte dry;
        Float wet;
        Byte up;
        Byte steady;
    }
}
