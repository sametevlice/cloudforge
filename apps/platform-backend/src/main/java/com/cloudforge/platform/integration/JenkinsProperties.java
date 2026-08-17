package com.cloudforge.platform.integration;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(
    prefix = "cloudforge.jenkins"
)
public record JenkinsProperties(
    String baseUrl,
    String username,
    String apiToken,
    String jobName
) {
}
