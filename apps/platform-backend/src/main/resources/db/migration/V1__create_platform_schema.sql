CREATE TABLE applications (
    id UUID PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    repository_url VARCHAR(500) NOT NULL UNIQUE,

    default_branch VARCHAR(100) NOT NULL,

    status VARCHAR(30) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL,

    updated_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT applications_status_check
        CHECK (status IN ('ACTIVE', 'DISABLED'))
);


CREATE TABLE deployments (
    id UUID PRIMARY KEY,

    application_id UUID NOT NULL,

    environment VARCHAR(30) NOT NULL,

    image_tag VARCHAR(255) NOT NULL,

    status VARCHAR(30) NOT NULL,

    requested_at TIMESTAMPTZ NOT NULL,

    started_at TIMESTAMPTZ,

    finished_at TIMESTAMPTZ,

    failure_reason TEXT,

    previous_task_definition VARCHAR(500),

    deployed_task_definition VARCHAR(500),

    CONSTRAINT fk_deployments_application
        FOREIGN KEY (application_id)
        REFERENCES applications(id)
        ON DELETE CASCADE,

    CONSTRAINT deployments_environment_check
        CHECK (
            environment IN (
                'DEVELOPMENT',
                'STAGING',
                'PRODUCTION'
            )
        ),

    CONSTRAINT deployments_status_check
        CHECK (
            status IN (
                'QUEUED',
                'RUNNING',
                'SUCCEEDED',
                'FAILED',
                'ROLLED_BACK'
            )
        )
);


CREATE INDEX idx_deployments_application
    ON deployments(application_id);


CREATE INDEX idx_deployments_requested_at
    ON deployments(requested_at DESC);


CREATE TABLE deployment_events (
    id BIGSERIAL PRIMARY KEY,

    deployment_id UUID NOT NULL,

    event_type VARCHAR(100) NOT NULL,

    message TEXT,

    created_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_deployment_events_deployment
        FOREIGN KEY (deployment_id)
        REFERENCES deployments(id)
        ON DELETE CASCADE
);


CREATE INDEX idx_deployment_events_deployment
    ON deployment_events(deployment_id);
