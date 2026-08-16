package com.cloudforge.platform.deployment;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class DeploymentEventService {

    private final DeploymentEventRepository repository;

    public DeploymentEventService(
        DeploymentEventRepository repository
    ) {
        this.repository = repository;
    }

    @Transactional
    public void record(
        Deployment deployment,
        DeploymentEventType type,
        String message
    ) {
        repository.save(
            new DeploymentEvent(
                deployment,
                type,
                message
            )
        );
    }

    @Transactional(readOnly = true)
    public List<DeploymentEventResponse> findByDeployment(
        UUID deploymentId
    ) {
        return repository
            .findAllByDeploymentIdOrderByCreatedAtAsc(
                deploymentId
            )
            .stream()
            .map(DeploymentEventResponse::from)
            .toList();
    }
}
