package com.jb.udp.Util;

import sun.rmi.runtime.Log;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class JBByte {
    public static byte[] bytes(Byte[] bytes) {
        byte[] bytes1 = new byte[bytes.length];

        for (int i = 0, len = bytes.length; i < len; i++) {
            bytes1[i] = bytes[i];
        }
        return bytes1;
    }

    public static byte[] bytes(List<Byte> list) {
        Byte[] bytes = list.toArray(new Byte[0]);
        byte[] bytes1 = new byte[bytes.length];

        for (int i = 0, len = bytes.length; i < len; i++) {
            bytes1[i] = bytes[i];
        }
        return bytes1;
    }

    public static byte[] bytes(int a) {
        List<Byte> lengths = new ArrayList<>();
        int i = 0;

        while ((byte) ((a >> (i * 8)) & 0xFF) != 0) {
            byte l = (byte)((a >> (i * 8)) & 0xFF);
            lengths.add(l);
            i += 1;
        }
        return bytes(lengths);
    }

    public static Byte[] toBytes(byte[] bytes) {
        Byte[] bytes1 = new Byte[bytes.length];

        for (int i = 0, len = bytes.length; i < len; i++) {
            bytes1[i] = bytes[i];
        }
        return bytes1;
    }

    public static Byte[] toBytes(int a) {
        return toList(a).toArray(new Byte[0]);
    }

    public static List<Byte> toList(byte[] bytes) {
        List<Byte> bytes1 = new ArrayList<>();

        for (byte aByte : bytes) {
            bytes1.add(aByte);
        }
        return bytes1;
    }

    public static List<Byte> toList(int a) {
        List<Byte> lengths = new ArrayList<>();
        int i = 0;
        byte l = -1;

        while (true) {
            l = (byte)((a >> (i * 8)) & 0xFF);
            if (l == 0) {
                break;
            }
            lengths.add(l);
            i += 1;
        }
        return lengths;
    }

    public static List<Byte> toList(int a, int limit) {
        List<Byte> lengths = new ArrayList<>();

        for (int i = 0; i < limit; i++) {
            byte l = (byte)((a >> (i * 8)) & 0xFF);
            lengths.add(l);
        }
        return lengths;
    }

    public static List<Byte> toList(String str) {
        int a = Integer.valueOf(str);
        return toList(a);
    }

    public static int toInt(byte[] bytes) {
        int a = 0;

        for (int i = 0; i < bytes.length; i++) {
            a = a | ((bytes[i] & 0xff) << (i * 8));
        }
        return a;
    }

    public static int toInt(List<Byte> bytes) {
        int a = 0;

        for (int i = 0; i < bytes.size(); i++) {
            a = a | ((bytes.get(i).intValue() & 0xff) << (i * 8));
        }
        return a;
    }

    public static String toStr(List<Byte> bytes) {
        byte[] bytes1 = bytes(bytes);
        return new String(bytes1, 0, bytes1.length, StandardCharsets.UTF_8);
    }

    public static String toStr(List<Byte> bytes, int len_len) {
        String str = null;

        if (len_len > 0) {
            List<Byte> lengths = bytes.subList(0, len_len);
            int len = JBByte.toInt(lengths);
            lengths.clear();
            List<Byte> tokens = bytes.subList(0, len);
            byte[] bytes1 = JBByte.bytes(tokens);
            tokens.clear();
            str = new String(bytes1, 0, bytes1.length);
        }
        return str;
    }
    /// 1 => A; 2 => B, 依次类推 4 => D
    public static String toXvHao(byte b) {
        int i = (b & 0xFF) + 64;
        char c = (char) i;
        return String.valueOf(c);
    }
    /// 罗马数字
    public static String toRoman(byte b) {
        StringBuilder res = new StringBuilder();
        byte temp = b;

        while (temp >= 100 || temp < 0) {
            res.append("C");
            temp -= 100;
        }

        while (temp >= 90) {
            res.append("XC");
            temp -= 90;
        }
        while (temp >= 50) {
            res.append("L");
            temp -= 50;
        }
        while (temp >= 40) {
            res.append("XL");
            temp -= 40;
        }
        while (temp >= 10) {
            res.append("X");
            temp -= 10;
        }
        while (temp >= 9) {
            res.append("IX");
            temp -= 9;
        }
        while (temp >= 5) {
            res.append("V");
            temp -= 5;
        }
        while (temp >= 4) {
            res.append("IV");
            temp -= 4;
        }
        while (temp >= 1) {
            res.append("I");
            temp -= 1;
        }
        return res.toString();
    }
}
