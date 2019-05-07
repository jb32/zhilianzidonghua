package com.jb.udp;

import com.jb.udp.Command.Order;
import com.jb.udp.Command.RW;
import com.jb.udp.Util.JBByte;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

final public class UDPCaches {
    private static Logger logger = LogManager.getLogger(UDPCaches.class);

    private Map<String, UDPCache> contents = new HashMap<>();
    private ExecutorService service = Executors.newSingleThreadExecutor();

    public void create(final String mid, final byte[] bytes) {
        service.execute(new Runnable() {
            @Override
            public void run() {
                Order order = new Order(bytes[0]);

                if (order.getRw().equals(RW.read)) {
                    StringBuilder key = new StringBuilder(mid + order.getRawValue());
                    byte length = bytes[1];

                    if (length != 0 && bytes.length >= length + 2) {
                        for (int i = 2; i < length + 2; i++) {
                            key.append(bytes[i] & 0xFF);
                        }
                    }
                    contents.put(key.toString(), new UDPCache());
                }
            }
        });
    }

    public void set(final String mid, final Order order, final byte[] rsp, final byte[] requestData) {
        service.execute(new Runnable() {
            @Override
            public void run() {
                List<Byte> bytes = JBByte.toList(rsp);
                List<Byte> checks = bytes.subList(0, bytes.size() - 1);
                Integer sum = 0;

                for (Byte aByte : checks) {
                    sum += aByte.intValue() & 0xFF;
                }
                bytes.remove(0);/// 命令码
                Byte rspCode = bytes.remove(0); /// 应答码

                Integer check;

                if ((rspCode & 0x80) == 0x80) {
                    /// 应答数据长度
                    List<Byte> subList = bytes.subList(0, 4);
                    int length = (int) UDPIterator.parse(JBByte.bytes(subList));
                    subList.clear();
                    /// 校验码
                    List<Byte> subList1 = bytes.subList(bytes.size() - 5, bytes.size() - 1);
                    check = (Integer) UDPIterator.parse(JBByte.bytes(subList1));
                    subList1.clear();
                    /// 长度校验
                    if (bytes.size() != length) {
                        return;
                    }
                } else {
                    if (bytes.size() < 1) {
                        return;
                    }
                    int length = bytes.remove(0).intValue() & 0xFF;

                    if (bytes.size() < 1) {
                        return;
                    }
                    check = bytes.remove(bytes.size() - 1).intValue();

                    if (bytes.size() != length) {
                        return;
                    }
                }
                sum += check;
                sum &= 0xFF;

                if (sum.byteValue() != 0) {
                    return;
                }

                if (order.getRw().equals(RW.read)) {
                    UDPCache udpCache = null;

                    String key = mid + order.getRawValue();
                    switch (order.getSub()) {
                        case curves:
                            key = key + (bytes.get(0) & 0xFF);
                            break;
                        case curve:
                            key = key + (bytes.get(0) & 0xFF) + (bytes.get(1) & 0xFF);
                            break;
                        case record:
                            key = key + (bytes.get(0) & 0xFF) + (bytes.get(1) & 0xFF) + (bytes.get(2) & 0xFF);
                            break;
                        default:
                            break;
                    }

                    if (contents.containsKey(key)) {
                        udpCache = contents.get(key);
                        udpCache.setDate(new Date());
                        udpCache.setResponse(requestData);
                        contents.put(key, udpCache);
                    }
                }
            }
        });
    }

    public UDPCache get(String mid, byte[] bytes) {
        Order order = new Order(bytes[0]);

        if (order.isNull()) {
            return null;
        }

        if (order.getRw().equals(RW.read)) {
            StringBuilder key = new StringBuilder(mid + order.getRawValue());
            byte length = bytes[1];

            if (length != 0 && bytes.length >= length + 2) {
                for (int i = 2; i < length + 2; i++) {
                    key.append(bytes[i] & 0xFF);
                }
            }
            UDPCache udpCache = contents.get(key.toString());

            if (udpCache != null) {
                Date cacheDate = udpCache.getDate();
                if (cacheDate == null || new Date().getTime() - cacheDate.getTime() >= 2000 ) {
                    return null;
                }
            }
            return udpCache;
        }
        return null;
    }
}
