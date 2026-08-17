package com.cloudforge.platform.deployment;

import com.cloudforge.platform.common.ResourceNotFoundException;
import com.cloudforge.platform.integration.DeploymentOrchestrator;
import com.cloudforge.platform.integration.DeploymentTriggerResult;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class DeploymentExecutionService {

    private final DeploymentRepository repository;
    private final DeploymentEventService eventService;
    private final DeploymentOrchestrator orchestrator;

    public DeploymentExecutionService(
        DeploymentRepository repository,
        DeploymentEventService eventService,
        DeploymentOrchestrator orchestrator
    ) {
        this.repository = repository;
        this.eventService = eventService;
        this.orchestrator = orchestrator;
    }

    @Transactional
    public void execute(UUID deploymentId) {

        Deployment deployment = repository
            .findById(deploymentId)
            .orElseThrow(() ->
                new ResourceNotFoundException(
                    "Deployment not found: "
                        + deploymentId
                )
            );

        try {
            deployment.markRunning();

            eventService.record(
                deployment,
                DeploymentEventType.STARTED,
                "Deployment execution started."
            );

            DeploymentTriggerResult result =
                orchestrator.trigger(deployment);

            eventService.record(
                deployment,
                DeploymentEventType.JENKINS_TRIGGERED,
                result.message()
            );

            if (result.completedImmediately()) {
                deployment.markSucceeded();

                eventService.record(
                    deployment,
                    DeploymentEventType.SUCCEEDED,
                    result.message()
                );
            }

        } catch (Exception exception) {

            deployment.markFailed(
                exception.getMessage()
            );

            eventService.record(
                deployment,
                DeploymentEventType.FAILED,
                exception.getMessage()
            );
        }
    }
}
