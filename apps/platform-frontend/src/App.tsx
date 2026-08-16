import {
  useEffect,
  useState,
} from 'react'

import {
  createApplication,
  createDeployment,
  getApplications,
  getDeployments,
  rollbackDeployment,
} from './api/cloudforge'

import type {
  CloudApplication,
  Deployment,
  DeploymentEnvironment,
} from './api/types'

import './App.css'

function App() {
  const [
    applications,
    setApplications,
  ] = useState<CloudApplication[]>([])

  const [
    selectedApplication,
    setSelectedApplication,
  ] = useState<CloudApplication | null>(null)

  const [
    deployments,
    setDeployments,
  ] = useState<Deployment[]>([])

  const [
    error,
    setError,
  ] = useState<string | null>(null)

  const [
    name,
    setName,
  ] = useState('')

  const [
    repositoryUrl,
    setRepositoryUrl,
  ] = useState('')

  const [
    imageTag,
    setImageTag,
  ] = useState('')

  const [
    environment,
    setEnvironment,
  ] = useState<DeploymentEnvironment>(
    'DEVELOPMENT',
  )

  async function loadApplications() {
    try {
      setError(null)

      const result =
        await getApplications()

      setApplications(result)

      if (
        result.length > 0
        && selectedApplication === null
      ) {
        setSelectedApplication(
          result[0],
        )
      }
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'Application load failed.',
      )
    }
  }

  async function loadDeployments(
    application: CloudApplication,
  ) {
    try {
      setError(null)

      const result =
        await getDeployments(
          application.id,
        )

      setDeployments(result)
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'Deployment load failed.',
      )
    }
  }

  useEffect(() => {
    void loadApplications()
  }, [])

  useEffect(() => {
    if (selectedApplication) {
      void loadDeployments(
        selectedApplication,
      )
    } else {
      setDeployments([])
    }
  }, [selectedApplication])

  async function handleCreateApplication(
    event: React.FormEvent<HTMLFormElement>,
  ) {
    event.preventDefault()

    try {
      setError(null)

      const created =
        await createApplication({
          name,
          repositoryUrl,
          defaultBranch: 'main',
        })

      setName('')
      setRepositoryUrl('')

      await loadApplications()

      setSelectedApplication(
        created,
      )
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'Application creation failed.',
      )
    }
  }

  async function handleDeploy(
    event: React.FormEvent<HTMLFormElement>,
  ) {
    event.preventDefault()

    if (!selectedApplication) {
      return
    }

    try {
      setError(null)

      await createDeployment(
        selectedApplication.id,
        {
          environment,
          imageTag,
        },
      )

      setImageTag('')

      await new Promise(
        resolve =>
          setTimeout(
            resolve,
            1000,
          ),
      )

      await loadDeployments(
        selectedApplication,
      )
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'Deployment failed.',
      )
    }
  }

  async function handleRollback(
    deploymentId: string,
  ) {
    if (!selectedApplication) {
      return
    }

    try {
      setError(null)

      await rollbackDeployment(
        deploymentId,
      )

      await new Promise(
        resolve =>
          setTimeout(
            resolve,
            1000,
          ),
      )

      await loadDeployments(
        selectedApplication,
      )
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'Rollback failed.',
      )
    }
  }

  return (
    <main className="page">
      <header className="hero">
        <div>
          <p className="eyebrow">
            SELF-SERVICE DELIVERY PLATFORM
          </p>

          <h1>
            CloudForge
          </h1>

          <p className="hero-description">
            Applications, deployments
            and rollback from one
            control plane.
          </p>
        </div>

        <div className="hero-badge">
          CONTROL PLANE
        </div>
      </header>

      {error && (
        <div className="error">
          {error}
        </div>
      )}

      <section className="grid">
        <article className="panel">
          <div className="panel-header">
            <div>
              <p className="panel-label">
                REGISTRY
              </p>

              <h2>
                Applications
              </h2>
            </div>

            <span className="counter">
              {applications.length}
            </span>
          </div>

          <form
            onSubmit={
              handleCreateApplication
            }
          >
            <label>
              Application name

              <input
                placeholder="todo-api"
                value={name}
                onChange={
                  event =>
                    setName(
                      event.target.value,
                    )
                }
                required
              />
            </label>

            <label>
              GitHub repository

              <input
                placeholder="https://github.com/user/repository"
                value={
                  repositoryUrl
                }
                onChange={
                  event =>
                    setRepositoryUrl(
                      event.target.value,
                    )
                }
                required
              />
            </label>

            <button type="submit">
              Add application
            </button>
          </form>

          <div className="application-list">
            {applications.length === 0 && (
              <p className="empty-state">
                No applications
                registered yet.
              </p>
            )}

            {applications.map(
              application => (
                <button
                  type="button"
                  className={
                    selectedApplication?.id
                      === application.id
                      ? 'application active'
                      : 'application'
                  }
                  key={application.id}
                  onClick={() =>
                    setSelectedApplication(
                      application,
                    )
                  }
                >
                  <div>
                    <strong>
                      {application.name}
                    </strong>

                    <small>
                      {
                        application
                          .repositoryUrl
                      }
                    </small>
                  </div>

                  <span>
                    {
                      application
                        .defaultBranch
                    }
                  </span>
                </button>
              ),
            )}
          </div>
        </article>

        <article className="panel">
          <div className="panel-header">
            <div>
              <p className="panel-label">
                DELIVERY
              </p>

              <h2>
                Deploy
              </h2>
            </div>
          </div>

          {selectedApplication ? (
            <>
              <div className="selected-app">
                <span>
                  Selected application
                </span>

                <strong>
                  {
                    selectedApplication
                      .name
                  }
                </strong>
              </div>

              <form
                onSubmit={
                  handleDeploy
                }
              >
                <label>
                  Environment

                  <select
                    value={
                      environment
                    }
                    onChange={
                      event =>
                        setEnvironment(
                          event.target
                            .value as DeploymentEnvironment,
                        )
                    }
                  >
                    <option value="DEVELOPMENT">
                      Development
                    </option>

                    <option value="STAGING">
                      Staging
                    </option>

                    <option value="PRODUCTION">
                      Production
                    </option>
                  </select>
                </label>

                <label>
                  Image tag / Git SHA

                  <input
                    placeholder="f1a2b3c4..."
                    value={
                      imageTag
                    }
                    onChange={
                      event =>
                        setImageTag(
                          event.target
                            .value,
                        )
                    }
                    required
                  />
                </label>

                <button type="submit">
                  Deploy application
                </button>
              </form>
            </>
          ) : (
            <p className="empty-state">
              Select or create an
              application first.
            </p>
          )}
        </article>
      </section>

      <section className="panel">
        <div className="panel-header">
          <div>
            <p className="panel-label">
              HISTORY
            </p>

            <h2>
              Deployment History
            </h2>
          </div>

          <span className="counter">
            {deployments.length}
          </span>
        </div>

        {!selectedApplication && (
          <p className="empty-state">
            Select an application to
            view deployments.
          </p>
        )}

        {selectedApplication
          && deployments.length === 0
          && (
            <p className="empty-state">
              No deployments for this
              application yet.
            </p>
          )}

        <div className="deployment-list">
          {deployments.map(
            deployment => (
              <article
                className="deployment"
                key={deployment.id}
              >
                <div className="deployment-info">
                  <strong>
                    {
                      deployment
                        .environment
                    }
                  </strong>

                  <p>
                    {
                      deployment
                        .imageTag
                    }
                  </p>

                  <small>
                    {new Date(
                      deployment
                        .requestedAt,
                    ).toLocaleString()}
                  </small>

                  {deployment
                    .rollbackOfDeploymentId
                    && (
                      <small className="rollback-info">
                        Rollback of{' '}
                        {
                          deployment
                            .rollbackOfDeploymentId
                        }
                      </small>
                    )}
                </div>

                <span
                  className={
                    `status status-${deployment.status.toLowerCase()}`
                  }
                >
                  {
                    deployment
                      .status
                  }
                </span>

                <button
                  type="button"
                  className="secondary-button"
                  onClick={() =>
                    void handleRollback(
                      deployment.id,
                    )
                  }
                >
                  Rollback
                </button>
              </article>
            ),
          )}
        </div>
      </section>
    </main>
  )
}

export default App
