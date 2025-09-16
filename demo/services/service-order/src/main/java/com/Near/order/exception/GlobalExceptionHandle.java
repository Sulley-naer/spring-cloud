package com.Near.order.exception;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandle {

    @ExceptionHandler(Throwable.class)
    public String handleException(Throwable throwable) {
        return throwable.getMessage();
    }
}
