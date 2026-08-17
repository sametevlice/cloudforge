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

    private final CallbackProperties
        callbackProperties;

    private final RestClient restClient;


    public JenkinsDeploymentOrchestrator(
        JenkinsProperties properties,
        CallbackProperties callbackProperties
    ) {

        this.properties = properties;

        this.callbackProperties =
            callbackProperties;


        validateConfiguration(
            properties,
            callbackProperties
        );


        this.restClient = RestClient
            .builder()
            .baseUrl(
                properties.baseUrl()
            )
            .defaultHeaders(
                headers ->
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

        String callbackUrl =
            buildCallbackUrl(
                deployment
            );


        ResponseEntity<Void> response =
            restClient
                .post()
                .uri(
                    uriBuilder ->
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
                            .queryParam(
                                "CLOUDFORGE_CALLBACK_URL",
                                callbackUrl
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


    private String buildCallbackUrl(
        Deployment deployment
    ) {

        String baseUrl =
            callbackProperties
                .baseUrl()
                .replaceAll(
                    "/+$",
                    ""
                );


        return baseUrl
            + "/api/internal/deployments/"
            + deployment.getId()
            + "/status";
    }


    private void validateConfiguration(
        JenkinsProperties properties,
        CallbackProperties callbackProperties
    ) {

        if (
            !StringUtils.hasText(
                properties.baseUrl()
            )
            || !StringUtils.hasText(
                properties.username()
            )
            || !StringUtils.hasText(
                properties.apiToken()
            )
            || !StringUtils.hasText(
                properties.jobName()
            )
        ) {

            throw new IllegalStateException(
                "Jenkins configuration is incomplete."
            );
        }


        if (
            !StringUtils.hasText(
                callbackProperties.baseUrl()
            )
        ) {

            throw new IllegalStateException(
                "CloudForge callback base URL is missing."
            );
        }
    }
}
