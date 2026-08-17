package com.cloudforge.platform.deployment;

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
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "deployment_events")
public class DeploymentEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(
        fetch = FetchType.LAZY,
        optional = false
    )
    @JoinColumn(
        name = "deployment_id",
        nullable = false
    )
    private Deployment deployment;

    @Enumerated(EnumType.STRING)
    @Column(
        name = "event_type",
        nullable = false,
        length = 100
    )
    private DeploymentEventType eventType;

    @Column(name = "message")
    private String message;

    @Column(
        name = "created_at",
        nullable = false
    )
    private Instant createdAt;

    protected DeploymentEvent() {
    }

    public DeploymentEvent(
        Deployment deployment,
        DeploymentEventType eventType,
        String message
    ) {
        this.deployment = deployment;
        this.eventType = eventType;
        this.message = message;
    }

    @PrePersist
    void onCreate() {
        createdAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public Deployment getDeployment() {
        return deployment;
    }

    public DeploymentEventType getEventType() {
        return eventType;
    }

    public String getMessage() {
        return message;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
