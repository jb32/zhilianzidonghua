package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;

public class DeviceBean extends BaseData {
    private String mid = "";
    private String ip = "";
    private Integer port = 0;
    private Boolean bind = false;
    private String remark = "";
    private Boolean online = false;

    public DeviceBean() {}

    public DeviceBean(String mid, String ip, Integer port, Boolean bind, String remark, Boolean online) {
        this.mid = mid;
        this.ip = ip;
        this.port = port;
        this.bind = bind;
        this.remark = remark;
        this.online = online;
    }

    public String getMid() {
        return mid;
    }

    public void setMid(String mid) {
        this.mid = mid;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getIp() {
        return ip;
    }

    public Integer getPort() {
        return port;
    }

    public Boolean getOnline() {
        return online;
    }

    public Boolean getBind() {
        return bind;
    }

    public void setBind(Boolean bind) {
        this.bind = bind;
    }
}
