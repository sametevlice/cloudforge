package com.cloudforge.platform.deployment;

import com.cloudforge.platform.application.CloudApplication;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "deployments")
public class Deployment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(
        fetch = FetchType.LAZY,
        optional = false
    )
    @JoinColumn(
        name = "application_id",
        nullable = false
    )
    private CloudApplication application;

    @Enumerated(EnumType.STRING)
    @Column(
        nullable = false,
        length = 30
    )
    private DeploymentEnvironment environment;

    @Column(
        name = "image_tag",
        nullable = false,
        length = 255
    )
    private String imageTag;

    @Enumerated(EnumType.STRING)
    @Column(
        nullable = false,
        length = 30
    )
    private DeploymentStatus status;

    @Column(
        name = "requested_at",
        nullable = false
    )
    private Instant requestedAt;

    @Column(name = "started_at")
    private Instant startedAt;

    @Column(name = "finished_at")
    private Instant finishedAt;

    @Column(name = "failure_reason")
    private String failureReason;

    @Column(name = "previous_task_definition")
    private String previousTaskDefinition;

    @Column(name = "deployed_task_definition")
    private String deployedTaskDefinition;

    /*
     * Eğer bu deployment bir rollback işlemi sonucunda
     * oluşturulduysa, hangi deployment'ın rollback'i
     * olduğunu burada tutuyoruz.
     *
     * Örnek:
     *
     * Deployment A -> bozuk sürüm
     * Deployment B -> A'nın rollback deployment'ı
     *
     * B.rollbackOfDeployment = A
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rollback_of_deployment_id")
    private Deployment rollbackOfDeployment;

    protected Deployment() {
    }

    public Deployment(
        CloudApplication application,
        DeploymentEnvironment environment,
        String imageTag
    ) {
        this.application = application;
        this.environment = environment;
        this.imageTag = imageTag;
        this.status = DeploymentStatus.QUEUED;
        this.requestedAt = Instant.now();
    }

    /*
     * Yeni bir rollback deployment'ı oluşturur.
     *
     * target:
     * Geri almak istediğimiz deployment.
     *
     * previousSuccessful:
     * Daha önce başarılı olmuş ve geri dönmek
     * istediğimiz deployment.
     */
    public static Deployment rollback(
        Deployment target,
        Deployment previousSuccessful
    ) {
        Deployment rollback = new Deployment(
            target.getApplication(),
            target.getEnvironment(),
            previousSuccessful.getImageTag()
        );

        rollback.rollbackOfDeployment = target;

        return rollback;
    }

    public UUID getId() {
        return id;
    }

    public CloudApplication getApplication() {
        return application;
    }

    public DeploymentEnvironment getEnvironment() {
        return environment;
    }

    public String getImageTag() {
        return imageTag;
    }

    public DeploymentStatus getStatus() {
        return status;
    }

    public Instant getRequestedAt() {
        return requestedAt;
    }

    public Instant getStartedAt() {
        return startedAt;
    }

    public Instant getFinishedAt() {
        return finishedAt;
    }

    public String getFailureReason() {
        return failureReason;
    }

    public String getPreviousTaskDefinition() {
        return previousTaskDefinition;
    }

    public String getDeployedTaskDefinition() {
        return deployedTaskDefinition;
    }

    /*
     * rollbackOfDeployment nesnesinin tamamını
     * API'ye vermek yerine yalnızca ID'sini veriyoruz.
     */
    public UUID getRollbackOfDeploymentId() {
        return rollbackOfDeployment == null
            ? null
            : rollbackOfDeployment.getId();
    }

    public void markRunning() {
        /*
         * Jenkins aynı callback'i yanlışlıkla
         * iki kez gönderirse sorun çıkarmıyoruz.
         */
        if (status == DeploymentStatus.RUNNING) {
            return;
        }

        if (status != DeploymentStatus.QUEUED) {
            throw new IllegalStateException(
                "Only QUEUED deployment can become RUNNING."
            );
        }

        status = DeploymentStatus.RUNNING;

        if (startedAt == null) {
            startedAt = Instant.now();
        }
    }

    public void markSucceeded() {
        if (status == DeploymentStatus.SUCCEEDED) {
            return;
        }

        if (status != DeploymentStatus.RUNNING) {
            throw new IllegalStateException(
                "Only RUNNING deployment can succeed."
            );
        }

        status = DeploymentStatus.SUCCEEDED;
        finishedAt = Instant.now();
        failureReason = null;
    }

    public void markFailed(String reason) {
        if (status == DeploymentStatus.FAILED) {
            return;
        }

        if (
            status != DeploymentStatus.RUNNING
            && status != DeploymentStatus.QUEUED
        ) {
            throw new IllegalStateException(
                "Deployment cannot transition to FAILED."
            );
        }

        status = DeploymentStatus.FAILED;
        finishedAt = Instant.now();
        failureReason = reason;
    }

    public void markRolledBack() {
        if (status == DeploymentStatus.ROLLED_BACK) {
            return;
        }

        if (
            status != DeploymentStatus.SUCCEEDED
            && status != DeploymentStatus.FAILED
            && status != DeploymentStatus.RUNNING
        ) {
            throw new IllegalStateException(
                "Deployment cannot be rolled back."
            );
        }

        status = DeploymentStatus.ROLLED_BACK;
        finishedAt = Instant.now();
    }

    /*
     * Jenkins/ECS gerçek deployment yaptığında
     * eski ve yeni ECS Task Definition bilgilerini
     * backend'e bildirebilecek.
     */
    public void updateTaskDefinitions(
        String previousTaskDefinition,
        String deployedTaskDefinition
    ) {
        if (previousTaskDefinition != null) {
            this.previousTaskDefinition =
                previousTaskDefinition;
        }

        if (deployedTaskDefinition != null) {
            this.deployedTaskDefinition =
                deployedTaskDefinition;
        }
    }
}
