ALTER TABLE deployments
    ADD COLUMN rollback_of_deployment_id UUID;

ALTER TABLE deployments
    ADD CONSTRAINT fk_deployments_rollback_of
        FOREIGN KEY (rollback_of_deployment_id)
        REFERENCES deployments(id)
        ON DELETE SET NULL;

CREATE INDEX idx_deployments_rollback_of
    ON deployments(rollback_of_deployment_id);
