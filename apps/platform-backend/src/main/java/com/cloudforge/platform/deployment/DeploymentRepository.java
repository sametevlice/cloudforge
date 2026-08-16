package com.cloudforge.platform.deployment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DeploymentRepository
    extends JpaRepository<Deployment, UUID> {

    List<Deployment>
        findAllByApplicationIdOrderByRequestedAtDesc(
            UUID applicationId
        );
}
