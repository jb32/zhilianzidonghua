package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;

public class UserBean extends BaseData {
    private String token;

    public UserBean(String name) {
        this.name = name;
    }

    private String name;

    public UserBean(String token, String name) {
        this.token = token;
        this.name = name;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
