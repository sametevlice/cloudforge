package com.cloudforge.platform.deployment;

import com.cloudforge.platform.application.ApplicationService;
import com.cloudforge.platform.application.CloudApplication;
import com.cloudforge.platform.common.ResourceNotFoundException;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class DeploymentService {

    private final DeploymentRepository repository;
    private final ApplicationService applicationService;
    private final DeploymentEventService eventService;
    private final ApplicationEventPublisher eventPublisher;

    public DeploymentService(
        DeploymentRepository repository,
        ApplicationService applicationService,
        DeploymentEventService eventService,
        ApplicationEventPublisher eventPublisher
    ) {
        this.repository = repository;
        this.applicationService = applicationService;
        this.eventService = eventService;
        this.eventPublisher = eventPublisher;
    }

    @Transactional
    public DeploymentResponse create(
        UUID applicationId,
        CreateDeploymentRequest request
    ) {
        CloudApplication application =
            applicationService.getEntity(applicationId);

        Deployment deployment =
            new Deployment(
                application,
                request.environment(),
                request.imageTag().trim()
            );

        Deployment saved =
            repository.save(deployment);

        eventService.record(
            saved,
            DeploymentEventType.REQUESTED,
            "Deployment requested."
        );

        eventPublisher.publishEvent(
            new DeploymentRequestedEvent(
                saved.getId()
            )
        );

        return DeploymentResponse.from(saved);
    }

    @Transactional(readOnly = true)
    public List<DeploymentResponse> findByApplication(
        UUID applicationId
    ) {
        applicationService.getEntity(applicationId);

        return repository
            .findAllByApplicationIdOrderByRequestedAtDesc(
                applicationId
            )
            .stream()
            .map(DeploymentResponse::from)
            .toList();
    }

    @Transactional(readOnly = true)
    public DeploymentResponse findById(UUID id) {
        Deployment deployment =
            repository
                .findById(id)
                .orElseThrow(() ->
                    new ResourceNotFoundException(
                        "Deployment not found: " + id
                    )
                );

        return DeploymentResponse.from(deployment);
    }
}
