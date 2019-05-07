package com.jb.udp.Bean;

import com.jb.udp.Base.BaseData;
import com.jb.udp.Enum.State;

import java.util.List;

public class ResultList extends BaseResult {
    private List<BaseData> data;

    public ResultList(State state, String msg, List<BaseData> data) {
        super(state, msg);
        this.data = data;
    }

    @Override
    public List<BaseData> getData() {
        return data;
    }
}
