package com.cloudforge.platform.deployment;

public enum DeploymentEventType {
    REQUESTED,
    STARTED,
    JENKINS_TRIGGERED,
    SUCCEEDED,
    FAILED,
    ROLLED_BACK
}
