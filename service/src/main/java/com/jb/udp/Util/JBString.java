package com.jb.udp.Util;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class JBString {
    public static String join(CharSequence delimiter,
                       Iterable<? extends CharSequence> elements) {
        Objects.requireNonNull(delimiter);
        Objects.requireNonNull(elements);
        StringBuilder builder = new StringBuilder();
        List<Integer> capacity = new ArrayList<>();

        for (CharSequence cs: elements) {
            builder.append(cs);
            capacity.add(cs.length());
        }

        for (int i = 0; i < capacity.size(); i++) {
            if (i != capacity.size() - 1) {
                builder.insert(i + capacity.get(i), delimiter);
            }
        }
        return builder.toString();
    }
}
