package com.cloudforge.platform.application;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/applications")
public class ApplicationController {

    private final ApplicationService service;

    public ApplicationController(
        ApplicationService service
    ) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<ApplicationResponse> create(
        @Valid @RequestBody
        CreateApplicationRequest request
    ) {
        ApplicationResponse response =
            service.create(request);

        return ResponseEntity
            .created(
                URI.create(
                    "/api/applications/" + response.id()
                )
            )
            .body(response);
    }

    @GetMapping
    public List<ApplicationResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public ApplicationResponse findById(
        @PathVariable UUID id
    ) {
        return service.findById(id);
    }
}
