package com.cloudforge.platform.common;

public class ResourceNotFoundException
    extends RuntimeException {

    public ResourceNotFoundException(String message) {
        super(message);
    }
}
