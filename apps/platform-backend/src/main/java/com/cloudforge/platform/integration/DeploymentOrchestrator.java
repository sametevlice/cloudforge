package com.cloudforge.platform.integration;

import com.cloudforge.platform.deployment.Deployment;

public interface DeploymentOrchestrator {

    DeploymentTriggerResult trigger(
        Deployment deployment
    );
}
