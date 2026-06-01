<template>
  <el-container class="shell">
    <el-aside width="232px" class="aside">
      <div class="brand">
        <el-icon><Connection /></el-icon>
        <span>FATE 联合建模平台</span>
      </div>
      <el-menu :default-active="$route.path" router background-color="#142033" text-color="#d9e4f2" active-text-color="#7dd3fc">
        <el-menu-item v-for="item in menus" :key="item.path" :index="item.path">
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.title }}</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div>
          <div class="title">{{ $route.meta.title }}</div>
          <div class="subtitle">原始数据不出域，任务与结果集中管理</div>
        </div>
        <div class="user">
          <el-tag type="info">{{ user.userInfo.role || 'ADMIN' }}</el-tag>
          <span>{{ user.userInfo.realName || user.userInfo.username }}</span>
          <el-button :icon="SwitchButton" @click="logout">退出</el-button>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { SwitchButton } from '@element-plus/icons-vue'
import { useUserStore } from '../stores/user'

const router = useRouter()
const user = useUserStore()
const menus = computed(() => user.menus.length ? user.menus : [
  { path: '/dashboard', title: '首页看板', icon: 'DataBoard' },
  { path: '/orgs', title: '机构管理', icon: 'OfficeBuilding' },
  { path: '/assets', title: '数据资产', icon: 'Coin' },
  { path: '/psi', title: '样本对齐', icon: 'Connection' },
  { path: '/tasks', title: '联邦建模', icon: 'Cpu' },
  { path: '/fate-engine', title: 'FATE 引擎', icon: 'Operation' },
  { path: '/reports', title: '模型评估', icon: 'TrendCharts' },
  { path: '/audit', title: '审计日志', icon: 'DocumentChecked' }
])

onMounted(() => user.loadMenus().catch(() => {}))

function logout() {
  user.logout()
  router.push('/login')
}
</script>

<style scoped>
.shell {
  min-height: 100vh;
}

.aside {
  background: #142033;
}

.brand {
  height: 64px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 18px;
  color: #fff;
  font-weight: 700;
}

.header {
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #e5ebf4;
  background: #fff;
}

.title {
  font-size: 20px;
  font-weight: 700;
}

.subtitle {
  margin-top: 4px;
  color: #7a8699;
  font-size: 13px;
}

.user {
  display: flex;
  align-items: center;
  gap: 12px;
}

.main {
  background: #f4f7fb;
}
</style>
