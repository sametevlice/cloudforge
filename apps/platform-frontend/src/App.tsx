import {
  useEffect,
  useState,
  type FormEvent,
} from 'react'

import {
  createApplication,
  createDeployment,
  getApplications,
  getDeploymentEvents,
  getDeployments,
  rollbackDeployment,
} from './api/cloudforge'

import type {
  CloudApplication,
  Deployment,
  DeploymentEnvironment,
  DeploymentEvent,
} from './api/types'

import './App.css'


function App() {

  /*
   * =========================================================
   * APPLICATION STATE
   * =========================================================
   */

  const [
    applications,
    setApplications,
  ] = useState<CloudApplication[]>([])

  const [
    selectedApplication,
    setSelectedApplication,
  ] = useState<CloudApplication | null>(null)


  /*
   * =========================================================
   * DEPLOYMENT STATE
   * =========================================================
   */

  const [
    deployments,
    setDeployments,
  ] = useState<Deployment[]>([])

  /*
   * AŞAMA 12
   *
   * Kullanıcının history içinden seçtiği deployment.
   *
   * Burada deployment objesinin tamamı yerine ID saklıyoruz.
   * Çünkü polling sırasında deployment objesi yenilenebilir.
   */
  const [
    selectedDeploymentId,
    setSelectedDeploymentId,
  ] = useState<string | null>(null)


  /*
   * Seçilen deployment'ın timeline event'leri.
   */
  const [
    deploymentEvents,
    setDeploymentEvents,
  ] = useState<DeploymentEvent[]>([])


  /*
   * =========================================================
   * FORM STATE
   * =========================================================
   */

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


  /*
   * =========================================================
   * UI STATE
   * =========================================================
   */

  const [
    error,
    setError,
  ] = useState<string | null>(null)


  /*
   * ID'sini sakladığımız deployment'ın
   * güncel halini deployment listesinden buluyoruz.
   *
   * Polling deployment listesini yenilediğinde
   * bu değer de otomatik güncellenecek.
   */
  const selectedDeployment =
    deployments.find(
      deployment =>
        deployment.id === selectedDeploymentId,
    ) ?? null


  /*
   * =========================================================
   * APPLICATION LOAD
   * =========================================================
   */

  async function loadApplications() {

    try {

      setError(null)

      const result =
        await getApplications()

      setApplications(result)

      /*
       * Henüz application seçilmemişse
       * ilk application otomatik seçilir.
       */
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
          : 'Applications could not be loaded.',
      )

    }
  }


  /*
   * =========================================================
   * DEPLOYMENT LOAD
   * =========================================================
   */

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
          : 'Deployments could not be loaded.',
      )

    }
  }


  /*
   * =========================================================
   * DEPLOYMENT EVENT LOAD
   *
   * AŞAMA 12
   * =========================================================
   */

  async function loadDeploymentEvents(
    deploymentId: string,
  ) {

    try {

      setError(null)

      const result =
        await getDeploymentEvents(
          deploymentId,
        )

      setDeploymentEvents(result)

    } catch (err) {

      setError(
        err instanceof Error
          ? err.message
          : 'Deployment timeline could not be loaded.',
      )

    }
  }


  /*
   * =========================================================
   * SAYFA İLK AÇILDIĞINDA APPLICATION'LARI GETİR
   * =========================================================
   */

  useEffect(() => {

    void loadApplications()

  }, [])


  /*
   * =========================================================
   * APPLICATION DEĞİŞTİĞİNDE DEPLOYMENT'LARI GETİR
   * =========================================================
   */

  useEffect(() => {

    if (!selectedApplication) {
      setDeployments([])
      setSelectedDeploymentId(null)
      setDeploymentEvents([])
      return
    }

    setSelectedDeploymentId(null)
    setDeploymentEvents([])

    void loadDeployments(
      selectedApplication,
    )

  }, [selectedApplication])


  /*
   * =========================================================
   * AŞAMA 12
   *
   * DEPLOYMENT SEÇİLDİĞİNDE TIMELINE'I GETİR
   * =========================================================
   */

  useEffect(() => {

    if (!selectedDeploymentId) {

      setDeploymentEvents([])

      return
    }

    void loadDeploymentEvents(
      selectedDeploymentId,
    )

  }, [selectedDeploymentId])


  /*
   * =========================================================
   * AŞAMA 13
   *
   * ACTIVE DEPLOYMENT VARSA 3 SANİYEDE BİR YENİLE
   * =========================================================
   */

  const hasActiveDeployment =
    deployments.some(
      deployment =>
        deployment.status === 'QUEUED'
        || deployment.status === 'RUNNING',
    )


  useEffect(() => {

    /*
     * Application seçilmemişse polling yapma.
     */
    if (!selectedApplication) {
      return
    }

    /*
     * QUEUED veya RUNNING deployment yoksa
     * polling'e gerek yok.
     */
    if (!hasActiveDeployment) {
      return
    }


    /*
     * 3 saniyede bir çalışacak timer.
     */
    const interval =
      window.setInterval(
        () => {

          /*
           * Deployment listesini tekrar backend'den al.
           */
          void loadDeployments(
            selectedApplication,
          )


          /*
           * Kullanıcı bir deployment timeline'ı
           * görüntülüyorsa event'leri de yenile.
           */
          if (selectedDeploymentId) {

            void loadDeploymentEvents(
              selectedDeploymentId,
            )

          }

        },
        3000,
      )


    /*
     * Component yeniden render edildiğinde
     * veya polling artık gerekmediğinde
     * eski timer'ı temizle.
     */
    return () => {

      window.clearInterval(
        interval,
      )

    }

  }, [
    selectedApplication,
    selectedDeploymentId,
    hasActiveDeployment,
  ])


  /*
   * =========================================================
   * APPLICATION CREATE
   * =========================================================
   */

  async function handleCreateApplication(
    event: FormEvent,
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

      /*
       * Yeni application'ı otomatik seç.
       */
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


  /*
   * =========================================================
   * DEPLOYMENT CREATE
   * =========================================================
   */

  async function handleDeploy(
    event: FormEvent,
  ) {

    event.preventDefault()

    if (!selectedApplication) {
      return
    }

    try {

      setError(null)

      const createdDeployment =
        await createDeployment(
          selectedApplication.id,
          {
            environment,
            imageTag,
          },
        )

      setImageTag('')

      /*
       * Yeni oluşturulan deployment'ı
       * timeline için otomatik seçiyoruz.
       */
      setSelectedDeploymentId(
        createdDeployment.id,
      )


      /*
       * Backend mock orchestrator çok hızlı olduğu için
       * kısa bir bekleme ardından listeyi tekrar alıyoruz.
       */
      await new Promise(
        resolve =>
          window.setTimeout(
            resolve,
            500,
          ),
      )

      await loadDeployments(
        selectedApplication,
      )

      await loadDeploymentEvents(
        createdDeployment.id,
      )

    } catch (err) {

      setError(
        err instanceof Error
          ? err.message
          : 'Deployment creation failed.',
      )

    }
  }


  /*
   * =========================================================
   * ROLLBACK
   * =========================================================
   */

  async function handleRollback(
    deploymentId: string,
  ) {

    if (!selectedApplication) {
      return
    }

    try {

      setError(null)

      const rollback =
        await rollbackDeployment(
          deploymentId,
        )

      /*
       * Yeni rollback deployment'ını
       * timeline'da otomatik seç.
       */
      setSelectedDeploymentId(
        rollback.id,
      )


      await new Promise(
        resolve =>
          window.setTimeout(
            resolve,
            500,
          ),
      )

      await loadDeployments(
        selectedApplication,
      )

      await loadDeploymentEvents(
        rollback.id,
      )

    } catch (err) {

      setError(
        err instanceof Error
          ? err.message
          : 'Rollback failed.',
      )

    }
  }


  /*
   * =========================================================
   * STATUS CSS CLASS
   * =========================================================
   */

  function statusClass(
    status: Deployment['status'],
  ) {

    return (
      'status '
      + status.toLowerCase()
    )
  }


  /*
   * =========================================================
   * UI
   * =========================================================
   */

  return (

    <main className="page">

      {/* ============================================= */}
      {/* HEADER                                        */}
      {/* ============================================= */}

      <header className="hero">

        <div>

          <p className="eyebrow">
            SELF-SERVICE DELIVERY PLATFORM
          </p>

          <h1>
            CloudForge
          </h1>

          <p className="hero-description">
            Applications, deployments,
            deployment history and rollback
            from one control plane.
          </p>

        </div>

      </header>


      {/* ============================================= */}
      {/* ERROR                                         */}
      {/* ============================================= */}

      {error && (

        <div className="error">
          {error}
        </div>

      )}


      {/* ============================================= */}
      {/* APPLICATION + DEPLOY                          */}
      {/* ============================================= */}

      <section className="grid">


        {/* APPLICATIONS */}

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

            <span className="count">
              {applications.length}
            </span>

          </div>


          <form
            onSubmit={
              handleCreateApplication
            }
          >

            <input
              placeholder="Application name"
              value={name}
              onChange={
                event =>
                  setName(
                    event.target.value,
                  )
              }
              required
            />

            <input
              placeholder="GitHub repository URL"
              value={repositoryUrl}
              onChange={
                event =>
                  setRepositoryUrl(
                    event.target.value,
                  )
              }
              required
            />

            <button
              className="primary-button"
              type="submit"
            >
              Add Application
            </button>

          </form>


          <div className="application-list">

            {applications.length === 0 && (

              <p className="empty">
                No applications registered yet.
              </p>

            )}


            {applications.map(
              application => (

                <button
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
                      {application.repositoryUrl}
                    </small>

                  </div>

                  <span>
                    {application.defaultBranch}
                  </span>

                </button>

              ),
            )}

          </div>

        </article>


        {/* DEPLOY */}

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

            <form
              onSubmit={
                handleDeploy
              }
            >

              <div className="selected-app">

                <span>
                  Selected Application
                </span>

                <strong>
                  {
                    selectedApplication
                      .name
                  }
                </strong>

              </div>


              <label>

                Environment

                <select
                  value={environment}
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

                Immutable Image Tag / Git SHA

                <input
                  placeholder="example: a1b2c3d4..."
                  value={imageTag}
                  onChange={
                    event =>
                      setImageTag(
                        event.target.value,
                      )
                  }
                  required
                />

              </label>


              <button
                className="primary-button"
                type="submit"
              >
                Start Deployment
              </button>

            </form>

          ) : (

            <p className="empty">
              Select an application first.
            </p>

          )}

        </article>

      </section>


      {/* ============================================= */}
      {/* DEPLOYMENT HISTORY                            */}
      {/* ============================================= */}

      <section className="panel">

        <div className="panel-header">

          <div>

            <p className="panel-label">
              DELIVERY HISTORY
            </p>

            <h2>
              Deployment History
            </h2>

          </div>

          <span className="count">
            {deployments.length}
          </span>

        </div>


        {deployments.length === 0 ? (

          <p className="empty">
            No deployments yet.
          </p>

        ) : (

          <div className="deployment-list">

            {deployments.map(
              deployment => (

                <article
                  className={
                    selectedDeploymentId
                      === deployment.id
                      ? 'deployment selected'
                      : 'deployment'
                  }
                  key={deployment.id}
                  onClick={() =>
                    setSelectedDeploymentId(
                      deployment.id,
                    )
                  }
                >

                  <div className="deployment-main">

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

                  </div>


                  <span
                    className={
                      statusClass(
                        deployment.status,
                      )
                    }
                  >
                    {deployment.status}
                  </span>


                  <button
                    className="secondary-button"
                    onClick={
                      event => {

                        /*
                         * Rollback butonuna basınca
                         * deployment card click event'i
                         * tetiklenmesin.
                         */
                        event.stopPropagation()

                        void handleRollback(
                          deployment.id,
                        )
                      }
                    }
                  >
                    Rollback
                  </button>

                </article>

              ),
            )}

          </div>

        )}

      </section>


      {/* ============================================= */}
      {/* AŞAMA 12                                      */}
      {/* DEPLOYMENT TIMELINE                           */}
      {/* ============================================= */}

      {selectedDeployment && (

        <section className="panel">

          <div className="panel-header">

            <div>

              <p className="panel-label">
                EXECUTION TIMELINE
              </p>

              <h2>
                Deployment Timeline
              </h2>

            </div>


            <span
              className={
                statusClass(
                  selectedDeployment.status,
                )
              }
            >
              {selectedDeployment.status}
            </span>

          </div>


          <div className="timeline-summary">

            <div>

              <span>
                Environment
              </span>

              <strong>
                {
                  selectedDeployment
                    .environment
                }
              </strong>

            </div>


            <div>

              <span>
                Image
              </span>

              <strong>
                {
                  selectedDeployment
                    .imageTag
                }
              </strong>

            </div>


            <div>

              <span>
                Deployment ID
              </span>

              <strong className="mono">
                {
                  selectedDeployment.id
                }
              </strong>

            </div>

          </div>


          {deploymentEvents.length === 0 ? (

            <p className="empty">
              No deployment events available.
            </p>

          ) : (

            <div className="timeline">

              {deploymentEvents.map(
                (event, index) => (

                  <article
                    className="timeline-event"
                    key={event.id}
                  >

                    <div className="timeline-marker">

                      <span>
                        {index + 1}
                      </span>

                    </div>


                    <div className="timeline-content">

                      <div className="timeline-title">

                        <strong>
                          {event.eventType}
                        </strong>

                        <span>
                          {new Date(
                            event.createdAt,
                          ).toLocaleString()}
                        </span>

                      </div>


                      {event.message && (

                        <p>
                          {event.message}
                        </p>

                      )}

                    </div>

                  </article>

                ),
              )}

            </div>

          )}

        </section>

      )}

    </main>

  )
}

export default App
