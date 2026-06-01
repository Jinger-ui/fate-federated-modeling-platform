import { http } from './http'

export const authApi = {
  login: (data) => http.post('/auth/login', data),
  me: () => http.get('/auth/me'),
  menus: () => http.get('/auth/menus')
}

export const orgApi = {
  list: () => http.get('/orgs'),
  create: (data) => http.post('/orgs', data)
}

export const assetApi = {
  list: () => http.get('/data-assets'),
  detail: (id) => http.get(`/data-assets/${id}`),
  create: (data) => http.post('/data-assets', data),
  validate: (id) => http.post(`/data-assets/${id}/validate`)
}

export const psiApi = {
  list: () => http.get('/psi/tasks'),
  create: (data) => http.post('/psi/tasks', data),
  result: (id) => http.get(`/psi/tasks/${id}/result`)
}

export const taskApi = {
  list: () => http.get('/federated/tasks'),
  create: (data) => http.post('/federated/tasks', data),
  submit: (id) => http.post(`/federated/tasks/${id}/submit`),
  runtime: (id) => http.get(`/federated/tasks/${id}/runtime`)
}

export const reportApi = {
  list: () => http.get('/reports'),
  compare: () => http.get('/reports/compare'),
  summary: (id) => http.get(`/reports/${id}/summary`),
  curves: (id) => http.get(`/reports/${id}/curves`)
}

export const dashboardApi = {
  overview: () => http.get('/dashboard/overview'),
  trend: () => http.get('/dashboard/task-trend'),
  modelCompare: () => http.get('/dashboard/model-compare'),
  activities: () => http.get('/dashboard/recent-activities')
}

export const auditApi = {
  logs: () => http.get('/audit/logs'),
  loginLogs: () => http.get('/audit/login-logs')
}
