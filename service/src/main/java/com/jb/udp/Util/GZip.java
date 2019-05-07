package com.jb.udp.Util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import sun.misc.BASE64Encoder;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

public class GZip {
    private static Logger logger = LogManager.getLogger(GZip.class);
    /**
     * 使用gzip进行压缩 base64
     * @param primStr 字符串形式
     * @return
     */
    public static String encoder(String primStr) throws IOException {
        if (primStr == null || primStr.isEmpty()) {
            return primStr;
        }
        byte[] gzip = encoder(primStr.getBytes());
        return new sun.misc.BASE64Encoder().encode(gzip);
    }

    /**
     * 使用gzip进行压缩 base64
     * @param bytes
     * @return
     */
    public static byte[] encoderBase64(byte[] bytes) throws IOException {
        if (bytes == null || bytes.length == 0) {
            return bytes;
        }
        byte[] encoder = encoder(bytes);
        String encode = new BASE64Encoder().encode(encoder);
        return encode.getBytes(StandardCharsets.UTF_8);
    }

    /**
     * 使用gzip进行压缩
     * @param bytes byte 形式
     * @return
     */
    public static byte[] encoder(byte[] bytes) throws IOException {
        if (bytes == null || bytes.length == 0) {
            return bytes;
        }
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        GZIPOutputStream gzipOutputStream = null;

        try {
            gzipOutputStream = new GZIPOutputStream(outputStream);
            gzipOutputStream.write(bytes);
        } finally {
            if (gzipOutputStream != null) {
                try {
                    gzipOutputStream.close();
                } catch (IOException e) {
                    logger.error(e.toString(), e);
                }
            }
        }
        return outputStream.toByteArray();
    }

    public static String decoderBase64(byte[] bytes) throws IOException {
        if (bytes == null || bytes.length == 0) {
            return "";
        }
        String s = new String(bytes, StandardCharsets.UTF_8);
//        String s = new String(bytes, 0, bytes.length);
        byte[] base64 = new sun.misc.BASE64Decoder().decodeBuffer(s);
        return decoder(base64);
    }

    public static String decoderBase64(String s) throws IOException {
        byte[] base64 = new sun.misc.BASE64Decoder().decodeBuffer(s);
        return decoder(base64);
    }

    /**
     * 使用gzip进行解压缩 base64
     * @param bytes
     * @return
     */
    public static String decoder(byte[] bytes) throws IOException {
        if (bytes == null || bytes.length == 0) {
            return "";
        }
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ByteArrayInputStream inputStream = null;
        GZIPInputStream gzipInputStream = null;
        String decompressed = null;

        try {
            inputStream = new ByteArrayInputStream(bytes);
            gzipInputStream = new GZIPInputStream(inputStream);
            byte[] buffer = new byte[1024];
            int offset = -1;
            while ((offset = gzipInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, offset);
            }
            decompressed = new String(outputStream.toByteArray(), StandardCharsets.UTF_8);
//            decompressed = outputStream.toString();
        } finally {
            if (gzipInputStream != null) {
                try {
                    gzipInputStream.close();
                } catch (IOException e) {
                    logger.error(e.toString(), e);
                }
            }

            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    logger.error(e.toString(), e);
                }
            }
            try {
                outputStream.close();
            } catch (IOException e) {
                logger.error(e.toString(), e);
            }
        }
        return decompressed;
    }

//    public static void main(String[] args) {
//        byte[] bytes = {0x22, 0x00, 0x5A, 0x4C, 0x57, 0x58, 0x31, 0x38, 0x30, 0x37, 0x32, 0x32, 0x30, 0x30, 0x30, 0x31, 0x0D, 0x0A, 0x01, 0x01, (byte) 0x90, 0x21, 0x26, 0x16, 0x26, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, (byte) 0xFE, 0x00, (byte) 0xE1, (byte) 0x85};
//
//    }
}
