package com.jb.udp;

final public class UDPIterator {
    private byte[] data;
    private Integer index = 0;

    UDPIterator(byte[] data) {
        this.data = data;
    }

    Number iterator(Integer offset) {
        byte[] bytes = new byte[offset];

        System.arraycopy(data, index, bytes, 0, offset);
        index += offset;

        return parse(bytes);
    }

    public static Number parse(byte[] bytes) {
        int offset = bytes.length;

        if (offset == 2 || offset == 3) {
            int result = 0;

            for (int i = 0; i < offset; i++) {
                int re = bytes[i] & 0xFF;
                re = re << i * 8;
                result |= re;
            }
            return result;
        } else if (offset == 4) {
            long result = 0L;

            for (int i = 0; i < offset; i++) {
                long re = bytes[i] & 0xFF;
                re = re << i * 8;
                result |= re;
            }
            return result;
        }
        return bytes[0];
    }
}
