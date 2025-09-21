package common.Response;

import lombok.Data;

@Data
public class Success {
    int code;
    String msg;
    Object data;

    public Success(int code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public Success(Object data) {
        this.code = 200;
        this.msg = "success";
        this.data = data;
    }
}