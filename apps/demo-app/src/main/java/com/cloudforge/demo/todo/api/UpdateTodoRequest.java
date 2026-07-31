package com.cloudforge.demo.todo.api;

import com.cloudforge.demo.todo.TodoStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateTodoRequest(
        @NotBlank
        @Size(max = 160)
        String title,

        @Size(max = 4000)
        String description,

        @NotNull
        TodoStatus status
) {
}
