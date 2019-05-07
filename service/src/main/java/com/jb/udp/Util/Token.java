package com.jb.udp.Util;

import com.jb.udp.Base.ZLError;
import com.jb.udp.Enum.State;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import net.minidev.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class Token {

    /** token秘钥，请勿泄露，请勿随便修改 backups:_zzzl_xjb_inteligence */
    private static final String SECRET = "zzzl_yanfabu_xjb_inteligence_token";
    /** token 过期时间: 10天 */
    private static final int calendarField = Calendar.DATE;
    private static final int calendarInterval = 10;

    public static String create(Integer userID) throws JOSEException {

        Date iatDate = new Date();
        Calendar nowTime = Calendar.getInstance();
        nowTime.add(calendarField, calendarInterval);
        Date expiresDate = nowTime.getTime();

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat();

        HashMap<String, Object> map = new HashMap<>();
        map.put("alg", "HS256");
        map.put("typ", "JWT");
        map.put("uid", userID);
        map.put("sta", simpleDateFormat.format(iatDate));
        map.put("exp", simpleDateFormat.format(expiresDate));

        String token = null;
        JWSHeader jwsHeader = new JWSHeader(JWSAlgorithm.HS256);
        Payload payload = new Payload(new JSONObject(map));
        JWSObject jwsObject = new JWSObject(jwsHeader, payload);
        JWSSigner jwsSigner = new MACSigner(SECRET);
        jwsObject.sign(jwsSigner);
        token = jwsObject.serialize();

        return token;
    }

    /**
     * 解密Token
     *
     * @param token
     * @return
     * @throws Exception
     */
    public static Map<String, Object> verify(String token) throws ParseException, JOSEException {
        //        解析token
        Map<String, Object> resultMap = new HashMap<>();

        JWSObject jwsObject = JWSObject.parse(token);
        //获取到载荷
        Payload payload = jwsObject.getPayload();

        //建立一个解锁密匙
        JWSVerifier jwsVerifier = new MACVerifier(SECRET);

        //判断token
        if (jwsObject.verify(jwsVerifier)) {
            resultMap.put("Result", 0);
            //载荷的数据解析成json对象。
            JSONObject jsonObject = payload.toJSONObject();
            resultMap.put("data", jsonObject);

            //判断token是否过期
            if (jsonObject.containsKey("exp")) {
                String expTimeDate = jsonObject.getAsString("exp");
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat();
                Date date = simpleDateFormat.parse(expTimeDate);
                long expTime = date.getTime();
                long nowTime = new Date().getTime();
                //判断是否过期
                if (nowTime > expTime) {
                    //已经过期
                    resultMap.clear();
                    resultMap.put("Result", 2);

                }
            }
        }else {
            resultMap.put("Result", 1);
        }
        return resultMap;
    }

    /**
     * 根据Token获取user_id
     *
     * @param token
     * @return user_id
     */
    public static int getAppUID(String token) throws ParseException, JOSEException, ZLError {
        Map<String, Object> validMap = verify(token);
        int i = (int) validMap.get("Result");

        if (i == 0) {
            JSONObject jsonObject = (JSONObject) validMap.get("data");
            Number uid = jsonObject.getAsNumber("uid");
            String uuid = jsonObject.getAsString("rspForUUID");
            return uid.intValue();
        } else {
            throw new ZLError(State.failure, "登录失效");
        }
    }
}
