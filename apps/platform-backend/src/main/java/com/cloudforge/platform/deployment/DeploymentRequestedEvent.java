package com.cloudforge.platform.deployment;

import java.util.UUID;

public record DeploymentRequestedEvent(
    UUID deploymentId
) {
}
