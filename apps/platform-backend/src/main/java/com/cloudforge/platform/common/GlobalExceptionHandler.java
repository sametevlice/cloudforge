package com.cloudforge.platform.common;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(
        ResourceNotFoundException exception
    ) {
        return build(
            HttpStatus.NOT_FOUND,
            exception.getMessage(),
            Map.of()
        );
    }

    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ApiError> handleDuplicate(
        DuplicateResourceException exception
    ) {
        return build(
            HttpStatus.CONFLICT,
            exception.getMessage(),
            Map.of()
        );
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(
        MethodArgumentNotValidException exception
    ) {
        Map<String, String> errors =
            new LinkedHashMap<>();

        exception
            .getBindingResult()
            .getFieldErrors()
            .forEach(error ->
                errors.put(
                    error.getField(),
                    error.getDefaultMessage()
                )
            );

        return build(
            HttpStatus.BAD_REQUEST,
            "Request validation failed.",
            errors
        );
    }

    private ResponseEntity<ApiError> build(
        HttpStatus status,
        String message,
        Map<String, String> validationErrors
    ) {
        ApiError error = new ApiError(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            message,
            validationErrors
        );

        return ResponseEntity
            .status(status)
            .body(error);
    }
}
