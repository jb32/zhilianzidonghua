package com.jb.udp.Enum;

import java.util.List;

public enum RunBug {
    tFailure        (1 << 7), /*传感器故障*/
    fanFailure      (1 << 6), /*循环风机缺相*/
    voltageOver     (1 << 5), /*电压超高限*/
    powerCut        (1 << 4), /*停电*/
    ctOver          (1 << 3), /*温度偏温*/
    htOver          (1 << 2); /*湿度偏温*/

    private int content;

    RunBug(int content) {
        this.content = content;
    }

    public static int encode(List<RunBug> states) {
        int result = 0;

        for (RunBug state : states) {
            result = result | state.content;
        }
        return result;
    }
}
