package com.Near.order.common.Response;

import lombok.Data;

@Data
public class Bad<t> {
    int code;
    String msg;
    t data;

    public Bad(int code, String msg, t data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }
}
