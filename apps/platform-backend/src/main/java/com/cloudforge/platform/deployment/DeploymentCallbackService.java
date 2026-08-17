package com.cloudforge.platform.deployment;

import com.cloudforge.platform.common.ResourceNotFoundException;
import com.cloudforge.platform.integration.CallbackTokenVerifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class DeploymentCallbackService {

    private final DeploymentRepository repository;
    private final DeploymentEventService eventService;
    private final CallbackTokenVerifier tokenVerifier;

    public DeploymentCallbackService(
        DeploymentRepository repository,
        DeploymentEventService eventService,
        CallbackTokenVerifier tokenVerifier
    ) {
        this.repository = repository;
        this.eventService = eventService;
        this.tokenVerifier = tokenVerifier;
    }

    @Transactional
    public DeploymentResponse updateStatus(
        UUID deploymentId,
        String callbackToken,
        DeploymentStatusCallbackRequest request
    ) {
        tokenVerifier.verify(callbackToken);

        Deployment deployment = repository
            .findById(deploymentId)
            .orElseThrow(() ->
                new ResourceNotFoundException(
                    "Deployment not found: "
                        + deploymentId
                )
            );

        deployment.updateTaskDefinitions(
            request.previousTaskDefinition(),
            request.deployedTaskDefinition()
        );

        String message =
            request.message() == null
                ? "Deployment status updated."
                : request.message();

        switch (request.status()) {

            case RUNNING -> {
                deployment.markRunning();

                eventService.record(
                    deployment,
                    DeploymentEventType.STARTED,
                    message
                );
            }

            case SUCCEEDED -> {
                deployment.markSucceeded();

                eventService.record(
                    deployment,
                    DeploymentEventType.SUCCEEDED,
                    message
                );
            }

            case FAILED -> {
                deployment.markFailed(message);

                eventService.record(
                    deployment,
                    DeploymentEventType.FAILED,
                    message
                );
            }

            case ROLLED_BACK -> {
                deployment.markRolledBack();

                eventService.record(
                    deployment,
                    DeploymentEventType.ROLLED_BACK,
                    message
                );
            }

            default -> throw new IllegalArgumentException(
                "Unsupported callback status: "
                    + request.status()
            );
        }

        return DeploymentResponse.from(deployment);
    }
}
