import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
import Login from '../views/Login.vue'
import AppLayout from '../layout/AppLayout.vue'
import Dashboard from '../views/Dashboard.vue'
import Orgs from '../views/Orgs.vue'
import Assets from '../views/Assets.vue'
import PsiTasks from '../views/PsiTasks.vue'
import FederatedTasks from '../views/FederatedTasks.vue'
import Reports from '../views/Reports.vue'
import Audit from '../views/Audit.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', component: Login },
    {
      path: '/',
      component: AppLayout,
      redirect: '/dashboard',
      children: [
        { path: 'dashboard', component: Dashboard, meta: { title: '首页看板' } },
        { path: 'orgs', component: Orgs, meta: { title: '机构管理' } },
        { path: 'assets', component: Assets, meta: { title: '数据资产' } },
        { path: 'psi', component: PsiTasks, meta: { title: '样本对齐' } },
        { path: 'tasks', component: FederatedTasks, meta: { title: '联邦建模' } },
        { path: 'reports', component: Reports, meta: { title: '模型评估' } },
        { path: 'audit', component: Audit, meta: { title: '审计日志' } }
      ]
    }
  ]
})

router.beforeEach((to) => {
  const store = useUserStore()
  if (to.path !== '/login' && !store.token) return '/login'
  if (to.path === '/login' && store.token) return '/dashboard'
})

export default router
