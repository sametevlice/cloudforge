package com.cloudforge.platform.deployment;

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
@RequestMapping("/api")
public class DeploymentController {

    private final DeploymentService service;
    private final DeploymentEventService eventService;

    public DeploymentController(
        DeploymentService service,
        DeploymentEventService eventService
    ) {
        this.service = service;
        this.eventService = eventService;
    }

    @PostMapping(
        "/applications/{applicationId}/deployments"
    )
    public ResponseEntity<DeploymentResponse> create(
        @PathVariable UUID applicationId,
        @Valid @RequestBody
        CreateDeploymentRequest request
    ) {
        DeploymentResponse response =
            service.create(
                applicationId,
                request
            );

        return ResponseEntity
            .created(
                URI.create(
                    "/api/deployments/" + response.id()
                )
            )
            .body(response);
    }

    @GetMapping(
        "/applications/{applicationId}/deployments"
    )
    public List<DeploymentResponse> findByApplication(
        @PathVariable UUID applicationId
    ) {
        return service.findByApplication(
            applicationId
        );
    }

    @GetMapping("/deployments/{id}")
    public DeploymentResponse findById(
        @PathVariable UUID id
    ) {
        return service.findById(id);
    }

    @GetMapping("/deployments/{id}/events")
    public List<DeploymentEventResponse> findEvents(
        @PathVariable UUID id
    ) {
        service.findById(id);

        return eventService.findByDeployment(id);
    }
}
