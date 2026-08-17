package com.cloudforge.platform.integration;

public record DeploymentTriggerResult(
    boolean completedImmediately,
    String message
) {

    public static DeploymentTriggerResult completed(
        String message
    ) {
        return new DeploymentTriggerResult(
            true,
            message
        );
    }

    public static DeploymentTriggerResult accepted(
        String message
    ) {
        return new DeploymentTriggerResult(
            false,
            message
        );
    }
}
