package com.cloudforge.platform.integration;

import com.cloudforge.platform.deployment.Deployment;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClient;

@Component
@ConditionalOnProperty(
    name = "cloudforge.deployment.orchestrator",
    havingValue = "jenkins"
)
public class JenkinsDeploymentOrchestrator
    implements DeploymentOrchestrator {

    private final JenkinsProperties properties;
    private final RestClient restClient;

    public JenkinsDeploymentOrchestrator(
        JenkinsProperties properties
    ) {
        this.properties = properties;

        validateConfiguration(properties);

        this.restClient = RestClient
            .builder()
            .baseUrl(properties.baseUrl())
            .defaultHeaders(headers ->
                headers.setBasicAuth(
                    properties.username(),
                    properties.apiToken()
                )
            )
            .build();
    }

    @Override
    public DeploymentTriggerResult trigger(
        Deployment deployment
    ) {
        ResponseEntity<Void> response =
            restClient
                .post()
                .uri(uriBuilder ->
                    uriBuilder
                        .pathSegment(
                            "job",
                            properties.jobName(),
                            "buildWithParameters"
                        )
                        .queryParam(
                            "IMAGE_TAG",
                            deployment.getImageTag()
                        )
                        .queryParam(
                            "DEPLOYMENT_ID",
                            deployment.getId()
                        )
                        .queryParam(
                            "TARGET_ENVIRONMENT",
                            deployment
                                .getEnvironment()
                                .name()
                        )
                        .build()
                )
                .retrieve()
                .toBodilessEntity();

        return DeploymentTriggerResult.accepted(
            "Jenkins accepted deployment request: "
                + response.getStatusCode()
        );
    }

    private void validateConfiguration(
        JenkinsProperties properties
    ) {
        if (
            !StringUtils.hasText(properties.baseUrl())
            || !StringUtils.hasText(properties.username())
            || !StringUtils.hasText(properties.apiToken())
            || !StringUtils.hasText(properties.jobName())
        ) {
            throw new IllegalStateException(
                "Jenkins configuration is incomplete."
            );
        }
    }
}
