package com.cloudforge.demo.todo.api;

import com.cloudforge.demo.todo.Todo;
import com.cloudforge.demo.todo.TodoStatus;

import java.time.Instant;
import java.util.UUID;

public record TodoResponse(
        UUID id,
        String title,
        String description,
        TodoStatus status,
        Instant createdAt,
        Instant updatedAt
) {
    public static TodoResponse from(Todo todo) {
        return new TodoResponse(
                todo.getId(),
                todo.getTitle(),
                todo.getDescription(),
                todo.getStatus(),
                todo.getCreatedAt(),
                todo.getUpdatedAt()
        );
    }
}
