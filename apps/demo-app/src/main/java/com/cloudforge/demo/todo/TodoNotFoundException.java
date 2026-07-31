package com.cloudforge.demo.todo;

import java.util.UUID;

public class TodoNotFoundException extends RuntimeException {

    public TodoNotFoundException(UUID id) {
        super("Todo bulunamadı: " + id);
    }
}
