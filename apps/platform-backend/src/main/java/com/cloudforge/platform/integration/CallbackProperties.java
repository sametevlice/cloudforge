package com.cloudforge.platform.integration;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(
    prefix = "cloudforge.callback"
)
public record CallbackProperties(
    String token
) {
}
