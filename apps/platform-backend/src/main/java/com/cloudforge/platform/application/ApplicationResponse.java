package com.cloudforge.platform.application;

import java.time.Instant;
import java.util.UUID;

public record ApplicationResponse(
    UUID id,
    String name,
    String repositoryUrl,
    String defaultBranch,
    ApplicationStatus status,
    Instant createdAt,
    Instant updatedAt
) {

    public static ApplicationResponse from(
        CloudApplication application
    ) {
        return new ApplicationResponse(
            application.getId(),
            application.getName(),
            application.getRepositoryUrl(),
            application.getDefaultBranch(),
            application.getStatus(),
            application.getCreatedAt(),
            application.getUpdatedAt()
        );
    }
}
