package com.cloudforge.platform.deployment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DeploymentRepository
    extends JpaRepository<Deployment, UUID> {

    /*
     * Bir application'a ait bütün deployment'ları
     * en yeniden en eskiye doğru getirir.
     */
    List<Deployment>
        findAllByApplicationIdOrderByRequestedAtDesc(
            UUID applicationId
        );

    /*
     * Rollback yaparken önceki başarılı deployment'ı bulur.
     *
     * Şartlar:
     *
     * - aynı application
     * - aynı environment
     * - status = SUCCEEDED
     * - mevcut deployment'tan daha eski
     *
     * Sonra en yeni olanı seçer.
     */
    Optional<Deployment>
        findFirstByApplicationIdAndEnvironmentAndStatusAndRequestedAtBeforeOrderByRequestedAtDesc(
            UUID applicationId,
            DeploymentEnvironment environment,
            DeploymentStatus status,
            Instant requestedAt
        );
}
