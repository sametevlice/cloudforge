export type ApplicationStatus =
  | 'ACTIVE'
  | 'DISABLED'

export type DeploymentEnvironment =
  | 'DEVELOPMENT'
  | 'STAGING'
  | 'PRODUCTION'

export type DeploymentStatus =
  | 'QUEUED'
  | 'RUNNING'
  | 'SUCCEEDED'
  | 'FAILED'
  | 'ROLLED_BACK'

export interface CloudApplication {
  id: string
  name: string
  repositoryUrl: string
  defaultBranch: string
  status: ApplicationStatus
  createdAt: string
  updatedAt: string
}

export interface Deployment {
  id: string
  applicationId: string
  environment: DeploymentEnvironment
  imageTag: string
  status: DeploymentStatus
  requestedAt: string
  startedAt: string | null
  finishedAt: string | null
  failureReason: string | null
  rollbackOfDeploymentId: string | null
}

export interface DeploymentEvent {
  id: number
  eventType: string
  message: string | null
  createdAt: string
}
