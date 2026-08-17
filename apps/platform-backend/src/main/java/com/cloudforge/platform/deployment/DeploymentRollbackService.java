package com.cloudforge.platform.deployment;

import com.cloudforge.platform.common.ResourceNotFoundException;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class DeploymentRollbackService {

    private final DeploymentRepository repository;
    private final DeploymentEventService eventService;
    private final ApplicationEventPublisher eventPublisher;

    public DeploymentRollbackService(
        DeploymentRepository repository,
        DeploymentEventService eventService,
        ApplicationEventPublisher eventPublisher
    ) {
        this.repository = repository;
        this.eventService = eventService;
        this.eventPublisher = eventPublisher;
    }

    @Transactional
    public DeploymentResponse rollback(
        UUID deploymentId
    ) {
        Deployment target = repository
            .findById(deploymentId)
            .orElseThrow(() ->
                new ResourceNotFoundException(
                    "Deployment not found: "
                        + deploymentId
                )
            );

        Deployment previous =
            repository
                .findFirstByApplicationIdAndEnvironmentAndStatusAndRequestedAtBeforeOrderByRequestedAtDesc(
                    target.getApplication().getId(),
                    target.getEnvironment(),
                    DeploymentStatus.SUCCEEDED,
                    target.getRequestedAt()
                )
                .orElseThrow(() ->
                    new IllegalStateException(
                        "No previous successful deployment exists."
                    )
                );

        Deployment rollback =
            Deployment.rollback(
                target,
                previous
            );

        Deployment saved =
            repository.save(rollback);

        eventService.record(
            saved,
            DeploymentEventType.REQUESTED,
            "Rollback requested. Restoring image "
                + previous.getImageTag()
        );

        eventPublisher.publishEvent(
            new DeploymentRequestedEvent(
                saved.getId()
            )
        );

        return DeploymentResponse.from(saved);
    }
}
