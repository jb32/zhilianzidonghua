package com.jb.service;

import com.alibaba.fastjson.JSONObject;
import com.jb.udp.Bean.ResultData;

public interface UserService {
    public ResultData info(JSONObject jsonObject);
    public ResultData login(JSONObject jsonObject);
}
