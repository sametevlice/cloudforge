package com.cloudforge.platform.deployment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DeploymentEventRepository
    extends JpaRepository<DeploymentEvent, Long> {

    List<DeploymentEvent>
        findAllByDeploymentIdOrderByCreatedAtAsc(
            UUID deploymentId
        );
}
