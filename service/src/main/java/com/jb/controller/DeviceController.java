package com.jb.controller;

import com.alibaba.fastjson.JSONObject;
import com.jb.service.DeviceService;
import com.jb.udp.Bean.BaseResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping("/device")
public class DeviceController {
    private DeviceService deviceService;
    @Autowired
    public void setDeviceService(DeviceService deviceService) {
        this.deviceService = deviceService;
    }

    @RequestMapping(value = "/list.do", produces = { "application/json;charset=UTF-8;"})
    @ResponseBody
    public String getDevices(HttpServletRequest request) {
        request.getParameterMap();
        JSONObject data = new JSONObject();

        Map<String, String[]> parameterMap = request.getParameterMap();
        for (Map.Entry<String, String[]> entry: parameterMap.entrySet()){
            data.put(entry.getKey(), entry.getValue()[0]);
        }
        BaseResult devices = deviceService.devices(data);
        return JSONObject.toJSONString(devices);
    }

    @RequestMapping(value = "/realTime.do", produces = { "application/json;charset=UTF-8;"})
    @ResponseBody
    public String realTimer(HttpServletRequest request) {
        JSONObject data = new JSONObject();

        Map<String, String[]> parameterMap = request.getParameterMap();
        for (Map.Entry<String, String[]> entry: parameterMap.entrySet()){
            data.put(entry.getKey(), entry.getValue()[0]);
        }
        BaseResult result = deviceService.realTime(data);
        return JSONObject.toJSONString(result);
    }
}
