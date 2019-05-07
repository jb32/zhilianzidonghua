package com.jb.udp;

import com.jb.udp.Bean.BaseResult;
import com.jb.udp.Interface.ProResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

final public class UDPManager {
    private static Logger logger = LogManager.getLogger(UDPManager.class);

    private UDPReceiver receiver;
    @Autowired
    public void setReceiver(UDPReceiver receiver) {
        this.receiver = receiver;
    }

    private DatagramSocket socket;
    private ExecutorService executorService = Executors.newSingleThreadExecutor();

    private volatile boolean close = true;

    public void init() {
        try {
            start();
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
        }
    }

    public void destroy() {
        close = false;
    }

    private void start() throws IOException {
        int size = 1024;
        byte[] buf_rev = new byte[size];
        int port = 59999;
        socket = new DatagramSocket(port);
        DatagramPacket packet = new DatagramPacket(buf_rev, size);

        logger.info("UDP服务器正在端口" + port + "上监听中...");

        while (close) {
            socket.receive(packet);

            if (!close) continue;
            byte[] contents = new byte[packet.getLength()];
            System.arraycopy(packet.getData(), 0, contents, 0, packet.getLength());
            InetAddress address = packet.getAddress();
            int port0 = packet.getPort();
            if (!close) continue;

            receiver.receiveUdp(contents, address, port0, new ProResponse() {
                @Override
                public void answer(UDPData data, InetAddress address, int port) {
                    try {
                        if (close) {
                            send(data.getTargetData(), address, port);
                        }
                    } catch (IOException e) {
                        logger.error(e.getMessage(), e);
                    }
                }
                @Override
                public void answer(BaseResult baseResult) {

                }
            });
        }
        socket.close();
    }

    public void send(byte[] bytes, InetAddress address, int port) throws IOException {
        if (address == null) {
            return;
        }
        DatagramPacket sendPacket = new DatagramPacket(bytes,
                bytes.length, address, port);
        socket.send(sendPacket);
    }
}
