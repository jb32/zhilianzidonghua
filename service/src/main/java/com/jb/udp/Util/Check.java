package com.jb.udp.Util;

import java.util.List;

public class Check {
    static public Boolean isRight(byte[] bytes) {
        int result = 0;

        for (byte bit:bytes){
            result = result + (bit & 0xff);
        }
        byte b = (byte)result;
        return b == 0;
    }

    static public byte checksum_zero(List<Byte> bytes) {
        int sum = 0;

        for (byte aByte:bytes) {
            sum += aByte;
        }
        int part = sum / 0x100 + 1;
        byte check = (byte) (0x100 * part - sum);
        return check;
    }

    static public Boolean checksum(List<Byte> bytes) {
        List<Byte> bytes1 = bytes.subList(0, bytes.size() - 1);
        int sum = 0;

        for (byte aByte:bytes1) {
            sum += aByte;
        }
        byte bsum = (byte)sum;
        byte bsum0 = bytes.get(bytes.size() - 1);
        return bsum == bsum0;
    }
}
