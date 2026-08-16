package com.cloudforge.platform.deployment;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

@Component
public class DeploymentRequestedListener {

    private final DeploymentExecutionService executionService;

    public DeploymentRequestedListener(
        DeploymentExecutionService executionService
    ) {
        this.executionService = executionService;
    }

    @Async
    @TransactionalEventListener(
        phase = TransactionPhase.AFTER_COMMIT
    )
    public void onDeploymentRequested(
        DeploymentRequestedEvent event
    ) {
        executionService.execute(
            event.deploymentId()
        );
    }
}
