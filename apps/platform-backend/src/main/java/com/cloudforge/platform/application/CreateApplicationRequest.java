package com.cloudforge.platform.application;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateApplicationRequest(

    @NotBlank
    @Size(max = 100)
    String name,

    @NotBlank
    @Size(max = 500)
    String repositoryUrl,

    @Size(max = 100)
    String defaultBranch

) {
}
