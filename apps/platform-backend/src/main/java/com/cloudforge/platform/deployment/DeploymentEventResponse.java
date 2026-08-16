package com.cloudforge.platform.deployment;

import java.time.Instant;

public record DeploymentEventResponse(
    Long id,
    DeploymentEventType eventType,
    String message,
    Instant createdAt
) {

    public static DeploymentEventResponse from(
        DeploymentEvent event
    ) {
        return new DeploymentEventResponse(
            event.getId(),
            event.getEventType(),
            event.getMessage(),
            event.getCreatedAt()
        );
    }
}
