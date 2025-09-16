package com.Near.order.common.Response;

import lombok.Data;

@Data
public class Bad {
    int code;
    String msg;
    Object data;

    public Bad(int code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public Bad(Object data) {
        this.code = 500;
        this.msg = "error";
        this.data = data;
    }
}
