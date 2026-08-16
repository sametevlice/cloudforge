package com.cloudforge.platform.deployment;

import java.time.Instant;
import java.util.UUID;

public record DeploymentResponse(
    UUID id,
    UUID applicationId,
    DeploymentEnvironment environment,
    String imageTag,
    DeploymentStatus status,
    Instant requestedAt,
    Instant startedAt,
    Instant finishedAt,
    String failureReason,
    UUID rollbackOfDeploymentId
) {

    public static DeploymentResponse from(
        Deployment deployment
    ) {
        return new DeploymentResponse(
            deployment.getId(),
            deployment.getApplication().getId(),
            deployment.getEnvironment(),
            deployment.getImageTag(),
            deployment.getStatus(),
            deployment.getRequestedAt(),
            deployment.getStartedAt(),
            deployment.getFinishedAt(),
            deployment.getFailureReason(),
            deployment.getRollbackOfDeploymentId()
        );
    }
}
