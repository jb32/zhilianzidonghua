package com.jb.udp;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jb.Mapper.DeviceMapper;
import com.jb.Mapper.HandleMapper;
import com.jb.Mapper.UserMapper;
import com.jb.model.Device;
import com.jb.model.Handle;
import com.jb.model.User;
import com.jb.udp.Base.BaseData;
import com.jb.udp.Base.ZLError;
import com.jb.udp.Bean.*;
import com.jb.udp.Command.Order;
import com.jb.udp.Command.SubOrder;
import com.jb.udp.Enum.DeviceType;
import com.jb.udp.Enum.State;
import com.jb.udp.Util.DateUtil;
import com.jb.udp.Util.GZip;
import com.jb.udp.Util.JBByte;
import com.jb.udp.Util.Token;
import com.nimbusds.jose.JOSEException;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;

import java.io.IOException;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Scope("prototype")
final public class UDPData {
    private static Logger logger = LogManager.getLogger(UDPData.class);
    private ExecutorService executorService = Executors.newSingleThreadExecutor();

    private UDPCaches udpCaches;
    @Autowired
    public void setUdpCaches(UDPCaches udpCaches) {
        this.udpCaches = udpCaches;
    }

    private SqlSessionTemplate sqlSession;
    @Autowired
    public void setSqlSession(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    private UDPReceiver receiver;
    @Autowired
    public void setReceiver(UDPReceiver receiver) {
        this.receiver = receiver;
    }

    private byte[] rawData;

    public byte[] getRawData() {
        return rawData;
    }

    private byte[] targetData;
    private JSONObject rawJson;
    private BaseResult baseResult;

    private String fromIdentifier;
    private DeviceType fromType;
    private DeviceType toType;
    private String toIdentifier;
    private Order order;
    private String token;
    private Integer uid;

    public UDPData() {}

    public String getMid() {
        if (fromType.equals(DeviceType.mid)) {
            return fromIdentifier;
        } else if (toType.equals(DeviceType.mid)) {
            return toIdentifier;
        }
        return fromIdentifier;
    }

    public UDPData decompose(JSONObject object, Order order) {
        this.order = order;
        this.fromType = DeviceType.html;
        this.fromIdentifier = object.getString("uuid");
        this.rawJson = object;

        if (object.containsKey("token")){
            this.token = object.getString("token");
        }

        if (this.order.isService()) {
            this.toType = DeviceType.html;
            this.toIdentifier = this.fromIdentifier;
        } else {
            this.toType = DeviceType.mid;
            this.toIdentifier = object.getString("mid");
        }
        return this;
    }

    public UDPData decompose(byte[] composeData) {
        String string = new String(composeData, StandardCharsets.UTF_8);

        if (string.length() > 4 && string.substring(0, 4).equals("ZLWX")) {

            byte[] dataArr = string.getBytes();
            int length = dataArr.length;

            if (dataArr[length - 2] == 0x0D && dataArr[length - 1] == 0x0A) {
                byte[] midArr = new byte[length - 2];
                System.arraycopy(dataArr, 0, midArr, 0, length - 2);
                fromIdentifier = new String(midArr, StandardCharsets.UTF_8);
                fromType = DeviceType.mid;
                toType = DeviceType.mid;
                toIdentifier = fromIdentifier;
                logger.info(toIdentifier + " 发来心跳信息");
            }
        } else {
            List<Byte> bytes = JBByte.toList(composeData);
            int check = bytes.remove(bytes.size() - 1).intValue() & 0xFF;
            int sum = 0;

            for (Byte aByte : bytes) {
                sum += aByte.intValue() & 0xFF;
            }
            sum += check;

            if ((byte)(sum & 0xFF) != 0) {
                return this;
            }
            order = new Order(bytes.remove(0) & 0xFF); /*命令码*/
            fromType = DeviceType.create(bytes.remove(0) & 0xFF);

            if (fromType.equals(DeviceType.phone)) {
                service(bytes); /// 从移动端发来的数据
            } else {
                device(bytes); /// 从自控发来的数据
            }
        }
        return this;
    }

    private void service(List<Byte> bytes) {
        logger.debug("============从手机端发来的数据============");
        //TODO: 登录 token
        int token_len_len = (bytes.remove(0).intValue() & 0xFF);
        token = JBByte.toStr(bytes, token_len_len);
        //TODO: 设备 uuid
        int uuid_len_len = bytes.remove(0).intValue() & 0xFF;
        String uuid = JBByte.toStr(bytes, uuid_len_len);

        int mid_len = bytes.remove(0).intValue() & 0xFF;

        String identifier = null;

        if (mid_len > 0) {
            List<Byte> midArr = bytes.subList(0, mid_len);
            identifier = JBByte.toStr(midArr);
            midArr.clear();
        }
        rawData = JBByte.bytes(bytes);
        fromIdentifier = uuid;

        if (order.isService()) {
            toType = DeviceType.phone;
            toIdentifier = uuid;
        } else {
            toType = DeviceType.mid;
            toIdentifier = identifier;
        }
    }

    private void device(List<Byte> bytes) {
        logger.info("=============从自控发来的数据================");

        List<Byte> bytes1 = bytes.subList(0, 2);
        uid = JBByte.toInt(bytes1); /// 用户ID

        logger.info("用户ID：" + uid);
        bytes1.clear();

        int mid_len = bytes.remove(0).intValue() & 0xFF;
        List<Byte> midArr = bytes.subList(0, mid_len);
        fromIdentifier = JBByte.toStr(midArr); /// 自控识别码
        midArr.clear();

        rawData = JBByte.bytes(bytes); /// 自控返回数据
        toType = DeviceType.phone;
        HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
        Handle handle = handleMapper.selectAppByUserId(uid);
        toIdentifier = handle.getDeviceid();
    }

    public void nextCompose() {
        if (fromType.equals(DeviceType.phone)) {
            BaseResult baseResult = check();

            if (baseResult != null) {
                targetData =  new byte[0];
                return;
            }
            if (toType.equals(DeviceType.phone)) {
                List<Byte> bytes = new ArrayList<>();
                JSONObject decode = decode(rawData);
                baseResult = forUdp(decode);
                bytes.add((byte) order.getRawValue());
                List<Byte> bytes1 = JBByte.toList(baseResult.getState(), 2);
                logger.info(order.toString() + baseResult.getState());
                bytes.addAll(bytes1);
                bytes.add((byte) 0); // mid 0

                JSONObject jsonObject = new JSONObject();
                jsonObject.put("msg", baseResult.getMsg());
                jsonObject.put("data", baseResult.getData());

                String rsp = jsonObject.toString();
                byte[] dabs = rsp.getBytes(StandardCharsets.UTF_8);

                try {
                    dabs = GZip.encoderBase64(dabs);
                } catch (IOException ignored) { }

                bytes.addAll(JBByte.toList(dabs));
                int sum = 0;

                for (byte re : bytes) {
                    sum += (re & 0xFF);
                }
                bytes.add((byte) (0 - (sum & 0xFF))); //校验和[1]

                targetData =  JBByte.bytes(bytes);
            } else {
                UDPCache cache = udpCaches.get(fromIdentifier, rawData);

                if (cache == null) {
                    /*启用缓存*/
                    udpCaches.create(toIdentifier, rawData);
                    List<Byte> bytes = new ArrayList<>();
                    bytes.add((byte) order.getRawValue()); /// 命令码
                    bytes.addAll(JBByte.toList(uid, 2)); /// 用户ID
                    bytes.addAll(JBByte.toList(rawData)); /// 自控命令
                    int sum = 0;
                    for (Byte aByte : bytes) {
                        sum += (aByte.intValue() & 0xFF);
                    }
                    byte check = (byte) (0 - (sum & 0xFF));
                    bytes.add(check);
                    targetData =  JBByte.bytes(bytes);
                } else {
                    toType = fromType;
                    toIdentifier = fromIdentifier;
                    targetData =  cache.getResponse();
                }
            }
        } else if (fromType.equals(DeviceType.html)) {
            baseResult = check();

            if (toType.equals(DeviceType.html)) {
                baseResult = forUdp(rawJson);
            } else {
                targetData = getDeviceData();
            }
        } else {
            if (toType.equals(DeviceType.phone)) {
                List<Byte> bytes = new ArrayList<>();
                bytes.add((byte) order.getRawValue()); /// 命令码
                bytes.addAll(JBByte.toList(State.success.getRawValue(), 2)); /// 响应码
                byte[] midArr = fromIdentifier.getBytes(StandardCharsets.UTF_8);
                bytes.add((byte) midArr.length); ///自控识别码长度
                bytes.addAll(JBByte.toList(midArr));/// 自控识别码
                bytes.addAll(JBByte.toList(rawData)); /// 自控响应数据
                int sum = 0;
                for (Byte aByte : bytes) {
                    sum += (aByte.intValue() & 0xFF);
                }
                byte check = (byte) (0 - (sum & 0xFF));
                bytes.add(check);
                byte[] requestData = JBByte.bytes(bytes);

                if (!order.getSub().equals(SubOrder.bind)) {
                    udpCaches.set(fromIdentifier, order, rawData, requestData);
                }
                targetData =  requestData;
            } else {
                String rsp = "SYS_Time " + DateUtil.nowDate();
                targetData = rsp.getBytes(StandardCharsets.UTF_8);
            }
        }
    }

    public BaseResult check() {

        BaseResult resultData = checkToken();

        if (resultData == null && uid != null) {
            resultData = checkSSO();
        }
        return resultData;
    }
    /// 移动端数据 解码
    private JSONObject decode(byte[] bytes) {
        JSONObject jsonObject;

        if (order.isService()) {
            try {
                String json = GZip.decoderBase64(bytes);
                String replace = json.replace("\\", "");
                jsonObject = JSON.parseObject(replace);
            } catch (IOException e) {
                jsonObject = new JSONObject();
            }
        } else {
            jsonObject = new JSONObject();
        }
        return jsonObject;
    }
    public BaseResult checkToken() {
        if (token != null) {
            BaseData baseData = new BaseData();

            try {
                uid = Token.getAppUID(token);
            } catch (ParseException | JOSEException e) {
                return new ResultData(State.failure, "登录失效", baseData);
            } catch (ZLError zlError) {
                return new ResultData(zlError.getState(), zlError.getMessage(), baseData);
            }

            if (loginExpired(fromIdentifier, uid, order)) {
                return new ResultData(State.failure, "登录失效", baseData);
            }
        }
        return null;
    }
    public BaseResult checkSSO() {
        HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);

        if (ssoLimit(fromIdentifier, uid, handleMapper)) {
            return new ResultData(State.loginSSO, "该账号在其他设备登录", new BaseData());
        }
        return null;
    }
    /**
     * @param uuid            UUID
     * @param uid             用户ID
     * @param handleMapper shu
     * @return 是否在其他设备登录
     */
    private boolean ssoLimit(String uuid, Integer uid, HandleMapper handleMapper) {
        Handle handle = handleMapper.selectAppByUserId(uid);

        if (handle == null) {
            return false;
        }
        return !handle.getDeviceid().equals(uuid);
    }
    /**
     * @param uuid  uuid
     * @param uid   用户ID
     * @param order 所属命令
     * @return 是否登录失效
     */
    private boolean loginExpired(String uuid, Integer uid, Order order) {
        boolean isToken = uid == null || uuid == null;

        if (order == null) {
            return isToken;
        }
        boolean isRequisite = order.getSub() == SubOrder.register ||
                order.getSub() == SubOrder.login ||
                order.getSub() == SubOrder.password;
        return isToken && !isRequisite;
    }
    /**
     * 命令分别执行
     * @param data            参数
     */
    public BaseResult forUdp(JSONObject data) {
        BaseResult baseData = null;
        String uuid = fromIdentifier;

        switch (order.getSub()) {
            case register:
                baseData = cmdRegister(uuid, data);
                break;
            case login:
                baseData = cmdLogin(uuid, data);
                break;
            case password:
                baseData = cmdModityPsd(uid, data);
                break;
            case userInfo:
                baseData = cmdUserInfo(uid);
                break;
            case addDevice:
                baseData = cmdAddDevice(uid, data);
                break;
            case deleteDevice:
                baseData = cmdDeleteDevice(uid, data);
                break;
            case editDevice:
                baseData = cmdEditDevice(uid, data);
                break;
            case devices:
                baseData = cmdDevices(uid);
                break;
            case bindDevice:
                baseData = cmdBindDevice(uid, data);
                break;
            default:
                break;
        }
        return baseData;
    }
    private ResultData cmdBindDevice(Integer uid, JSONObject param) {

        BaseData baseData = null;
        if (uid == null) {
            return new ResultData(State.failure, "登录失效请返回重新登录", baseData);
        }

        String mid = param.getString("mid");
        Boolean isbind = param.getBoolean("isbind");

        if (mid != null) {
            HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
//            DeviceMapper deviceMapper = sqlSession.getMapper(DeviceMapper.class);

            Handle[] handles = handleMapper.selectByDeviceId(mid);

            for (Handle handle : handles) {
                if (handle.getUserid().equals(uid)) {
                    handle.setBind(isbind);
                } else {
                    handle.setBind(false);
                }
                handleMapper.updateByPrimaryKeySelective(handle);
            }
        }
        return new ResultData(State.success, "", baseData);
    }
    ///TODO: 命令
    /**
     * app 命令 注册
     * @param uuid            UUID
     * @param data            参数
     */
    private ResultData cmdRegister(String uuid, JSONObject data) {
        String name = data.getString("name");
        String pwd = data.getString("password");
        String pwdMD5 = DigestUtils.md5Hex(pwd);
        String card = data.getString("card");
        card = DigestUtils.md5Hex(card);

        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.selectByName(name);
        BaseData baseData = new BaseData();

        if (user == null) {
            user = new User();
            user.setName(name);
            user.setPassword(pwdMD5);
            user.setCard(card);

            int add = userMapper.insertSelective(user);

            if (add != 0) {
                return new ResultData(State.success, "成功", baseData);
            } else {
                return new ResultData(State.failure, "失败", baseData);
            }
        } else {
            return new ResultData(State.failure, "该用户已存在", baseData);
        }
    }
    /**
     * app 命令 登录
     * @param uuid            uuid
     * @param data            data
     */
    private ResultData cmdLogin(String uuid, JSONObject data) {
        return login(uuid, data);
    }

    public ResultData login(String uuid, JSONObject data) {
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        String name = data.getString("name");
        String pwd = data.getString("password");
        String pwdMD5 = DigestUtils.md5Hex(pwd);
        String card = null;
        BaseData baseData = new BaseData();

        if (data.containsKey("card")) {
            card = data.getString("card");
            card = DigestUtils.md5Hex(card);
            if (card.length() == 0) {
                card = null;
            }
        }
        User user = userMapper.selectByName(name);

        if (user != null) {/*如果user不为空，则用户存在*/

            if (user.getPassword().equals(pwdMD5)) {/*校验密码*/
                HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
                Handle handle = handleMapper.selectAppByUserId(user.getId());

                // 如果无绑定设备，则绑定现有设备
                if (handle == null) {
                    handle = new Handle();
                    logger.info(user.getId() + "user id");
                    handle.setUserid(user.getId());
                    handle.setDeviceid(uuid);
                    handle.setType(DeviceType.phone.getRawValue());
                    handleMapper.insertSelective(handle);
                }

                if (card != null) {/*绑定登录*/
                    String card0 = user.getCard();/*获取用户的证件号*/
                    /*校验证件号*/
                    if (card.equals(card0)) {
                        handle.setUserid(user.getId());
                        handle.setDeviceid(uuid);
                        handleMapper.updateByPrimaryKeySelective(handle);
                        /*已经绑定该手机正常登录*/
                        return getUserBean(name, user);
                    }
                } else {/*card 为null 普通登录*/
                    /*如果绑定设备UUID等于当前UUID则为登录成功*/
                    if (!handle.getDeviceid().equals(uuid)) {
                        return new ResultData(State.loginCard, "请输入证件号重新登录", baseData);
                    } else {
                        return getUserBean(name, user);
                    }
                }
            } else {
                return new ResultData(State.failure, "密码错误", baseData);
            }
        }
        return new ResultData(State.failure, "账号错误", baseData);
    }
    private ResultData getUserBean(String name, User user) {
        try {
            String token = Token.create(user.getId());
            UserBean userBean = new UserBean(token, name);
            return new ResultData(State.success, "", userBean);
        } catch (JOSEException e) {
            return new ResultData(State.failure, "登录失败，请重新登录", new BaseData());
        }
    }
    /**
     * 获取绑定的设备列表
     * @param uid             用户id
     */
    private ResultList cmdDevices(Integer uid) {
        return devices(uid);
    }
    public ResultList devices(Integer uid) {
        if (uid == null) {
            return new ResultList(State.failure, "登录失效请返回重新登录", null);
        }
        HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
        DeviceMapper deviceMapper = sqlSession.getMapper(DeviceMapper.class);
        List<BaseData> dataList = new ArrayList<>();
        Handle[] handles = handleMapper.selectMidsByUserId(uid);

        for (Handle handle : handles) {
            Device device = deviceMapper.selectByPrimaryKey(handle.getDeviceid());

            if (device != null) {
                Boolean online = receiver.isOnline(handle.getDeviceid());
                DeviceBean deviceBean = new DeviceBean(handle.getDeviceid(), device.getIp(), device.getPort(), handle.getBind(), handle.getRemark(), online);
                dataList.add(deviceBean);

                if (deviceBean.getOnline()) {
                    logger.info(deviceBean.getMid() +  " online");
                }
            }
        }
        if (dataList.size() == 0) {
            return new ResultList(State.success, "您还没有绑定设备", dataList);
        } else {
            return new ResultList(State.success, "", dataList);
        }
    }
    /**
     * 绑定设备
     * @param uid             用户ID
     * @param data            参数
     */
    private BaseResult cmdAddDevice(Integer uid, JSONObject data) {
        String mid = data.getString("deviceId");
        HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);

        Handle handle = handleMapper.selectMidByUserId(uid, mid);
        BaseData baseData = new BaseData();

        if (handle == null) {
            if (uid == null) {
                return new ResultData(State.failure, "登录失效请返回重新登录", baseData);
            }
            handle = data.toJavaObject(Handle.class);
            handle.setUserid(uid);
            handle.setType(0);

            DeviceMapper deviceMapper = sqlSession.getMapper(DeviceMapper.class);
            Device device = deviceMapper.selectByPrimaryKey(mid);

            if (device == null) {
                return new ResultData(State.failure, "没有发现您的设备，请连接网络后重试", baseData);
            }
            int add = handleMapper.insertSelective(handle);

            if (add != 0) {
                return new ResultData(State.success, "添加成功", baseData);
            }
            return new ResultData(State.failure, "添加失败，请重新添加", baseData);
        } else {
            return new ResultData(State.failure, "您的设备已添加", baseData);
        }
    }
    /**
     * 解除设备绑定
     *  @param uid             用户ID
     * @param data             data
     */
    private BaseResult cmdDeleteDevice(Integer uid, JSONObject data) {
        if (uid == null) {
            return new ResultData(State.failure, "登录失效请返回重新登录", null);
        }
        String mid = data.getString("mid");
        BaseData baseData = new BaseData();

        if (mid.length() != 0) {
            HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
            int delete = handleMapper.deleteByUserid(uid, mid);

            if (delete != 0) {
                return new ResultData(State.success, "成功", baseData);
            }
        }
        return new ResultData(State.failure, "失败", baseData);
    }
    private BaseResult cmdEditDevice(Integer uid, JSONObject param) {
        if (uid == null) {
            return new ResultData(State.failure, "登录失效请返回重新登录", null);
        }
        String mid = param.getString("mid");
        String remark = param.getString("remark");
        DeviceBean baseData = new DeviceBean();

        if (mid != null && mid.length() != 0) {
            HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
            Handle handle = handleMapper.selectMidByUserId(uid, mid);
            handle.setRemark(remark == null ? mid : remark);
            int update = handleMapper.updateByPrimaryKeySelective(handle);

            if (update != 0) {
                return new ResultData(State.success, "成功", baseData);
            }
            return new ResultData(State.failure, "失败", baseData);
        }
        return new ResultData(State.failure, "失败", baseData);
    }
    /**
     * app 命令 用户详情
     * @param uid             用户id
     */
    private BaseResult cmdUserInfo(Integer uid) {
        if (uid == null) {
            return new ResultData(State.failure, "登录失效请返回重新登录", null);
        }
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.selectByPrimaryKey(uid);
        BaseData baseData = new BaseData();

        if (user == null) {
            return new ResultData(State.failure, "获取用户信息失败", baseData);
        }
        UserBean userBean = new UserBean(user.getName());
        return new ResultData(State.success, "", userBean);
    }
    /**
     * 修改密码
     * @param data            参数
     */
    private BaseResult cmdModityPsd(Integer uid, JSONObject data) {
        String name = null;

        if (uid == null) {
            return new ResultData(State.failure, "登录失效请返回重新登录", null);
        }

        if (data.containsKey("name")) {
            name = data.getString("name");
        }
        String card = data.getString("card");
        String password = data.getString("password");
        password = DigestUtils.md5Hex(password);
        card = DigestUtils.md5Hex(card);
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        BaseData baseData = new BaseData();

        // 忘记密码
        if (name != null) {
            User user = userMapper.selectByName(name);

            if (user == null) {
                return new ResultData(State.failure, "用户不存在", baseData);
            }
            user.setPassword(password);
            int update = userMapper.updateByPrimaryKeySelective(user);

            if (update == 0) {
                return new ResultData(State.failure, "修改失败，请稍后重试", baseData);
            }
            return new ResultData(State.success, "", baseData);
        } else { // 修改密码
            User user = userMapper.selectByPrimaryKey(uid);

            if (user == null) {
                return new ResultData(State.failure, "用户不存在", baseData);
            }
            user.setPassword(password);
            int update = userMapper.updateByPrimaryKeySelective(user);

            if (update == 0) {
                return new ResultData(State.failure, "修改失败，请稍后重试", baseData);
            }
            return new ResultData(State.success, "成功", baseData);
        }
    }

    public byte[] getDeviceData() {
        List<Byte> encode = encode();
        return JBByte.bytes(encode);
    }

    // TODO: - encode 编码
    List<Byte> encode() {
        List<Byte> datas = null;

        switch (order.getSub()) {
            case status:
                break;
            case realTime:
                break;
            case curves:
                datas = encodeCurves();
                break;
            case curve:
                datas = encodeCurve();
                break;
            case run:
                datas = encodeRun();
                break;
            case curveCoding:
                datas = encodeCurveCoding();
                break;
            case curveNum:
                datas = encodeCurveNum();
                break;
            case shed:
                datas = encodeShed();
                break;
            case time:
                datas = encodeTime();
                break;
            case record:
                datas = encodeRecord();
                break;
            case burner_status:
                break;
            case burner_fire:
                break;
            case burner_pass_fire:
                break;
            case burner_off:
                break;
            default:
                datas = new ArrayList<>();
        }
        if (datas == null) {
            datas = new ArrayList<>();
        }
        List<Byte> bytes = new ArrayList<>();
        bytes.add((byte) order.getRawValue()); // 命令码
        bytes.add((byte) datas.size()); // 命令数据长度
        bytes.addAll(datas); //datas.size()

        if (rawJson.containsKey("password") && order.getRawValue() >= 0) {
            List<Byte> pw = JBByte.toList(rawJson.getString("password"));
            bytes.addAll(pw); //密码【3】
        }
        int sum = 0;

        for (Byte aByte : bytes) {
            sum += aByte & 0xFF;
        }
        bytes.add((byte) (0 - sum)); //校验和[1]
        return bytes;
    }

    /*曲线*/
    private List<Byte> encodeCurves() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("coding").byteValue());
        JSONArray curves = rawJson.getJSONArray("curves");

        if (curves != null) {
            for (int i = 0, len = curves.size(); i < len; i++) {
                JSONObject curve = curves.getJSONObject(i);
                codes.add(curve.getInteger("dry").byteValue());
                Float wetF = curve.getFloat("wet");
                Integer wetI = wetF.intValue();
                Byte wet = wetF - wetI > 0 ? (byte) (wetI | 0x80) : wetI.byteValue();
                codes.add(wet);
                codes.add(curve.getInteger("up").byteValue());
                codes.add(curve.getInteger("steady").byteValue());
                codes.add((byte) 0);
                codes.add((byte) 0);
            }
        }
        return codes;
    }

    private List<Byte> encodeCurve() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("coding").byteValue());
        codes.add(rawJson.getInteger("curveNum").byteValue());
        JSONObject curve = rawJson.getJSONObject("curve");

        Integer dry = Integer.parseInt(curve.getString("dry"));
        codes.add(dry.byteValue());

        String wetStr = curve.getString("wet");
        Float wetF = Float.parseFloat(wetStr);
        Integer wetI = wetF.intValue();
        Byte wet = wetF - wetI > 0 ? (byte) (wetI | 0x80) : wetI.byteValue();
        codes.add(wet);
        codes.add(curve.getInteger("up").byteValue());
        codes.add(curve.getInteger("steady").byteValue());
        codes.add((byte) 0);
        codes.add((byte) 0);
        return codes;
    }

    private List<Byte> encodeRun() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("run").byteValue());
        return codes;
    }

    private List<Byte> encodeCurveCoding() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("coding").byteValue());
        return codes;
    }

    private List<Byte> encodeCurveNum() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("curveNum").byteValue());
        return codes;
    }

    private List<Byte> encodeShed() {
        List<Byte> codes = new ArrayList<>();
        codes.add(rawJson.getInteger("shed").byteValue());
        return codes;
    }

    private List<Byte> encodeTime() {
        List<Byte> codes = new ArrayList<>();
        Integer bakeTimes = rawJson.getInteger("bakeTimes");

        if (bakeTimes != null) {
            codes.add((byte) (bakeTimes & 0xFF));
        } else {
            return codes;
        }
        Integer year = rawJson.getInteger("year");
        Integer month = rawJson.getInteger("month");
        Integer day = rawJson.getInteger("day");
        Integer hour = rawJson.getInteger("hour");
        Integer minute = rawJson.getInteger("minute");

        if (year != null && month != null && day != null && hour != null && minute != null) {
            codes.add(year.byteValue());
            codes.add(month.byteValue());
            codes.add(day.byteValue());
            codes.add(hour.byteValue());
            codes.add(minute.byteValue());
        }
        return codes;
    }

    /// 命令码=0x09(R)，读取分机记录数据
    private List<Byte> encodeRecord() {
        int bakeTimes = rawJson.getIntValue("bakeTimes") & 0xFF;
        int num = rawJson.getIntValue("num");
        List<Byte> codes = JBByte.toList(num, 2);
        codes.add(0, (byte) bakeTimes);
        return codes;
    }

    public void addDevice(final InetAddress address, final int port) {

        executorService.execute(new Runnable() {
            @Override
            public void run() {
                DeviceMapper deviceMapper = sqlSession.getMapper(DeviceMapper.class);
                deviceMapper.insertOnDuplicate(fromIdentifier, address.getHostAddress(), port, fromType.getRawValue());

                if (fromType.equals(DeviceType.phone)) {
                    HandleMapper handleMapper = sqlSession.getMapper(HandleMapper.class);
                    Handle handle = handleMapper.selectAppByUserId(uid);

                    if (handle == null && uid != null) {
                        handle = new Handle();
                        handle.setUserid(uid);
                        handle.setDeviceid(fromIdentifier);
                        handle.setType(1);
                        handleMapper.insertSelective(handle);
                    }
                }
            }
        });
    }

    public boolean isOwn() {
        return fromIdentifier.equals(toIdentifier);
    }

    public boolean isPhoneToDevice() {
        return fromType.equals(DeviceType.phone) && toType.equals(DeviceType.mid);
    }

    public boolean isDeviceToPhone() {
        return fromType.equals(DeviceType.mid) && toType.equals(DeviceType.phone);
    }

    public byte[] getTargetData() {
        return targetData;
    }

    public String getFromIdentifier() {
        return fromIdentifier;
    }

    public DeviceType getFromType() {
        return fromType;
    }

    public DeviceType getToType() {
        return toType;
    }

    public String getToIdentifier() {
        return toIdentifier;
    }

    public int getUid() {
        return uid;
    }

    public BaseResult getBaseResult() {
        return baseResult;
    }

    public Order getOrder() {
        return order;
    }
}
