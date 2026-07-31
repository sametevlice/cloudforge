package com.cloudforge.demo.version;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

@RestController
@RequestMapping("/api/version")
public class VersionController {

    private final String applicationVersion;
    private final String gitCommit;

    public VersionController(
            @Value("${cloudforge.application-version:development}") String applicationVersion,
            @Value("${cloudforge.git-commit:local}") String gitCommit
    ) {
        this.applicationVersion = applicationVersion;
        this.gitCommit = gitCommit;
    }

    @GetMapping
    public Map<String, Object> getVersion() {
        return Map.of(
                "application", "cloudforge-demo-app",
                "version", applicationVersion,
                "commit", gitCommit,
                "timestamp", Instant.now().toString()
        );
    }
}
