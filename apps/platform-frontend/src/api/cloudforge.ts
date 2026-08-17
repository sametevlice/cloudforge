import type {
  CloudApplication,
  Deployment,
  DeploymentEnvironment,
  DeploymentEvent,
} from './types'

const API_BASE =
  import.meta.env.VITE_API_BASE_URL || '/api'

async function request<T>(
  path: string,
  init?: RequestInit,
): Promise<T> {
  const response = await fetch(
    `${API_BASE}${path}`,
    {
      ...init,

      headers: {
        'Content-Type': 'application/json',
        ...init?.headers,
      },
    },
  )

  if (!response.ok) {
    const body = await response.text()

    throw new Error(
      body ||
        `Request failed: ${response.status}`,
    )
  }

  return response.json() as Promise<T>
}


export function getApplications() {
  return request<CloudApplication[]>(
    '/applications',
  )
}


export function createApplication(
  input: {
    name: string
    repositoryUrl: string
    defaultBranch: string
  },
) {
  return request<CloudApplication>(
    '/applications',
    {
      method: 'POST',
      body: JSON.stringify(input),
    },
  )
}


export function getDeployments(
  applicationId: string,
) {
  return request<Deployment[]>(
    `/applications/${applicationId}/deployments`,
  )
}


export function createDeployment(
  applicationId: string,
  input: {
    environment: DeploymentEnvironment
    imageTag: string
  },
) {
  return request<Deployment>(
    `/applications/${applicationId}/deployments`,
    {
      method: 'POST',
      body: JSON.stringify(input),
    },
  )
}


export function getDeploymentEvents(
  deploymentId: string,
) {
  return request<DeploymentEvent[]>(
    `/deployments/${deploymentId}/events`,
  )
}


export function rollbackDeployment(
  deploymentId: string,
) {
  return request<Deployment>(
    `/deployments/${deploymentId}/rollback`,
    {
      method: 'POST',
    },
  )
}
