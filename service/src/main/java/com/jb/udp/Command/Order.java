package com.jb.udp.Command;

public class Order {
    private SubOrder sub;
    private RW rw;
    private boolean isNull = false;

    private int rawValue;

    public Order(SubOrder sub, RW rw) {
        this.sub = sub;
        this.rw = rw;

        if (sub.getRawValue() < 0) {
            this.rawValue = sub.getRawValue();
        } else {
            this.rawValue = sub.getRawValue() | rw.getRawValue();
        }
    }

    public Order(int rawValue) {
        this.rawValue = rawValue & 0xFF;

        if (this.rawValue >= SubOrder.bindDevice.getRawValue()) {
            SubOrder subOrder = SubOrder.create(this.rawValue);

            if (subOrder == null) {
                isNull = true;
            }
            this.sub = subOrder;
            this.rw = RW.read;
        } else {
            SubOrder subOrder = SubOrder.create(this.rawValue & 0x1F);

            if (subOrder == null) {
                isNull = true;
            }
            RW rw = RW.create(this.rawValue & 0x40);
            if (rw == null) {
                isNull = true;
            }
            this.sub = subOrder;
            this.rw = rw;
        }
    }

    public boolean isService() {
        return rawValue >= SubOrder.bindDevice.getRawValue();
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Order)) {
            return false;
        }
        Order order = (Order) obj;
        return rawValue == order.rawValue;
    }

    @Override
    public String toString() {
        return sub.toString() + ": " + rw.toString();
    }

    public int getRawValue() {
        return rawValue;
    }

    public SubOrder getSub() {
        return sub;
    }

    public RW getRw() {
        return rw;
    }

    public boolean isNull() {
        return isNull;
    }
}

//public enum Order {
//    encode {
//        public Integer encode(SubOrder sub, RW rwValue) {
//            rwValue = rwValue == null ? RW.read : rwValue;
//            return sub.getRawValue() | rwValue.getRawValue();
//        }
//    },
//    receiveUdp {
//        public Pair<SubOrder, RW> receiveUdp(int code) {
//            SubOrder sub = SubOrder.create(code & 0x1F);
//            RW rw = RW.create(code & 0x80);
//
//            if (sub.getRawValue() < 0) {
//                return new Pair<>(sub, null);
//            }
//            return new Pair<>(sub, rw);
//        }
//    };
//}

