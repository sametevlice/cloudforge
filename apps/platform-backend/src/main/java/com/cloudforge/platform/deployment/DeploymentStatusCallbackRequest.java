package com.cloudforge.platform.deployment;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record DeploymentStatusCallbackRequest(

    @NotNull
    DeploymentStatus status,

    @Size(max = 2000)
    String message,

    @Size(max = 500)
    String previousTaskDefinition,

    @Size(max = 500)
    String deployedTaskDefinition

) {
}
