package com.cloudforge.platform;

import com.cloudforge.platform.integration.JenkinsProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(
    JenkinsProperties.class
)
public class CloudForgePlatformApplication {

    public static void main(String[] args) {
        SpringApplication.run(
            CloudForgePlatformApplication.class,
            args
        );
    }
}
