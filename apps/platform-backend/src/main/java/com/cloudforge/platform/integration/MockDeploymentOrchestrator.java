package com.cloudforge.platform.integration;

import com.cloudforge.platform.deployment.Deployment;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(
    name = "cloudforge.deployment.orchestrator",
    havingValue = "mock",
    matchIfMissing = true
)
public class MockDeploymentOrchestrator
    implements DeploymentOrchestrator {

    @Override
    public DeploymentTriggerResult trigger(
        Deployment deployment
    ) {
        return DeploymentTriggerResult.completed(
            "Mock deployment completed successfully."
        );
    }
}
