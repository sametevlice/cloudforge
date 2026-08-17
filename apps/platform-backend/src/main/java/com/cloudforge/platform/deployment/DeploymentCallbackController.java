package com.cloudforge.platform.deployment;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping(
    "/api/internal/deployments"
)
public class DeploymentCallbackController {

    private static final String CALLBACK_HEADER =
        "X-CloudForge-Callback-Token";

    private final DeploymentCallbackService service;

    public DeploymentCallbackController(
        DeploymentCallbackService service
    ) {
        this.service = service;
    }

    @PostMapping("/{id}/status")
    public DeploymentResponse updateStatus(
        @PathVariable UUID id,

        @RequestHeader(CALLBACK_HEADER)
        String callbackToken,

        @Valid @RequestBody
        DeploymentStatusCallbackRequest request
    ) {
        return service.updateStatus(
            id,
            callbackToken,
            request
        );
    }
}
