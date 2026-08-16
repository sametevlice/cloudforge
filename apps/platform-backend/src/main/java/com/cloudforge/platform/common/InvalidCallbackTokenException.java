package com.cloudforge.platform.common;

public class InvalidCallbackTokenException
    extends RuntimeException {

    public InvalidCallbackTokenException() {
        super("Invalid deployment callback token.");
    }
}
