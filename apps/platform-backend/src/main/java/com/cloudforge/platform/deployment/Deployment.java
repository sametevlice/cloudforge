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
    @Column(nullable = false, length = 30)
    private DeploymentEnvironment environment;

    @Column(
        name = "image_tag",
        nullable = false,
        length = 255
    )
    private String imageTag;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
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

    public void markRunning() {
        if (status != DeploymentStatus.QUEUED) {
            throw new IllegalStateException(
                "Only QUEUED deployment can become RUNNING."
            );
        }

        status = DeploymentStatus.RUNNING;
        startedAt = Instant.now();
        finishedAt = null;
        failureReason = null;
    }

    public void markSucceeded() {
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
        if (
            status == DeploymentStatus.SUCCEEDED
                || status == DeploymentStatus.ROLLED_BACK
        ) {
            throw new IllegalStateException(
                "Completed deployment cannot fail."
            );
        }

        status = DeploymentStatus.FAILED;
        failureReason = reason;
        finishedAt = Instant.now();
    }

    public void markRolledBack() {
        if (
            status != DeploymentStatus.SUCCEEDED
                && status != DeploymentStatus.FAILED
        ) {
            throw new IllegalStateException(
                "Only SUCCEEDED or FAILED deployment can be rolled back."
            );
        }

        status = DeploymentStatus.ROLLED_BACK;
        finishedAt = Instant.now();
    }

    public void setPreviousTaskDefinition(
        String previousTaskDefinition
    ) {
        this.previousTaskDefinition = previousTaskDefinition;
    }

    public void setDeployedTaskDefinition(
        String deployedTaskDefinition
    ) {
        this.deployedTaskDefinition = deployedTaskDefinition;
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
}
