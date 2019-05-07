package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;
import com.jb.udp.Enum.State;

public class ResultData extends BaseResult {
    private BaseData data;

    public ResultData(State state, String msg, BaseData data) {
        super(state, msg);
        this.data = data;
    }

    @Override
    public BaseData getData() {
        return data;
    }
}
