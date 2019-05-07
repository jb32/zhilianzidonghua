package com.jb.service;

import com.alibaba.fastjson.JSONObject;
import com.jb.udp.Bean.BaseResult;

public interface DeviceService {
    public BaseResult devices(JSONObject data);
    public BaseResult realTime(JSONObject data);
}
