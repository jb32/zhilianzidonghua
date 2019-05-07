package com.jb.controller;

import com.alibaba.fastjson.JSONObject;
import com.jb.service.UserService;
import com.jb.udp.Bean.ResultData;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    private static Logger logger = LogManager.getLogger(UserController.class);

    private UserService userService;
    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
    @RequestMapping(value = "/info.do", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public String info(HttpServletRequest request) {
        JSONObject data = new JSONObject();

        Map<String, String[]> parameterMap = request.getParameterMap();
        for (Map.Entry<String, String[]> entry: parameterMap.entrySet()){
            data.put(entry.getKey(), entry.getValue()[0]);
        }
        ResultData info = userService.info(data);
        return JSONObject.toJSONString(info);
    }
    @RequestMapping(value = "/login.do", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public String login(HttpServletRequest request) {
        JSONObject data = new JSONObject();

        Map<String, String[]> parameterMap = request.getParameterMap();
        for (Map.Entry<String, String[]> entry: parameterMap.entrySet()){
            data.put(entry.getKey(), entry.getValue()[0]);
        }
        ResultData login = userService.login(data);
        return JSONObject.toJSONString(login);
    }
}
