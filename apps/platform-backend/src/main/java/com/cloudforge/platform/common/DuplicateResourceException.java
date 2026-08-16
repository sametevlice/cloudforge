package com.cloudforge.platform.common;

public class DuplicateResourceException
    extends RuntimeException {

    public DuplicateResourceException(String message) {
        super(message);
    }
}
