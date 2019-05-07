package com.jb.udp.Util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
    /**
     * 或得时间类型
     * @author JinYihao
     *
     */
    public enum TimeType {
        EMdhmszy("EEE MMM dd HH:mm:ss z yyyy"),
        yMdHms("yyyy-MM-dd HH:mm:ss"),
        yMdHm("yyyy-MM-dd HH:mm"),
        yMdH("yyyy-MM-dd HH"),
        yMd("yyyy-MM-dd"),
        yMdHms_("yyyy_MM_dd_HH_mm_ss");
        // 成员变量
        private String value;
        // 构造方法
        private TimeType(String value) {
            this.value = value;
        }
        public String val(){
            return this.value;
        }
    }
    /**
     * long 转换   日期格式
     * @param longValue  long类型
     * @return   2017-09-01
     */
    public static String longToDate(long longValue) {
        SimpleDateFormat sdf= new SimpleDateFormat(TimeType.yMdHms.value);
        return sdf.format(new Date(longValue));
    }

    public static String nowDate() {
        long l = System.currentTimeMillis();
        String s = longToDate(l);
        return s;
    }


}
