package com.cloudforge.platform.deployment;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateDeploymentRequest(

    @NotNull
    DeploymentEnvironment environment,

    @NotBlank
    @Size(max = 255)
    String imageTag

) {
}
