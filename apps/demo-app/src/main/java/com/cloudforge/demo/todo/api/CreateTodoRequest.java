package com.cloudforge.demo.todo.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateTodoRequest(
        @NotBlank
        @Size(max = 160)
        String title,

        @Size(max = 4000)
        String description
) {
}
