<template>
  <main class="login">
    <section class="login-copy">
      <h1>多方数据安全联合建模平台</h1>
      <p>面向银行与运营商信用风险预测，统一管理样本对齐、联邦训练、评估报告与审计日志。</p>
      <div class="privacy">原始数据不出域 · FATE 联邦计算 · 平台化任务编排</div>
    </section>
    <el-form class="login-form" :model="form" @submit.prevent="submit">
      <h2>平台登录</h2>
      <el-form-item>
        <el-input v-model="form.username" size="large" placeholder="用户名" :prefix-icon="User" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="form.password" size="large" placeholder="密码" show-password :prefix-icon="Lock" />
      </el-form-item>
      <el-button type="primary" size="large" :loading="loading" @click="submit">登录</el-button>
      <div class="hint">默认账号：admin / 123456</div>
    </el-form>
  </main>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock } from '@element-plus/icons-vue'
import { useUserStore } from '../stores/user'

const router = useRouter()
const store = useUserStore()
const loading = ref(false)
const form = reactive({ username: 'admin', password: '123456' })

async function submit() {
  loading.value = true
  try {
    await store.login(form)
    router.push('/dashboard')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr 390px;
  align-items: center;
  gap: 56px;
  padding: 64px 9vw;
  background: linear-gradient(135deg, #0e1726 0%, #17324d 48%, #edf6ff 48%, #f6f9fd 100%);
}

.login-copy {
  color: #fff;
}

.login-copy h1 {
  max-width: 760px;
  margin: 0;
  font-size: 44px;
  line-height: 1.18;
}

.login-copy p {
  max-width: 680px;
  font-size: 18px;
  line-height: 1.8;
  color: #d8e8f8;
}

.privacy {
  margin-top: 26px;
  color: #91e4ff;
  font-weight: 700;
}

.login-form {
  background: #fff;
  border: 1px solid #dbe5f0;
  border-radius: 8px;
  padding: 28px;
  box-shadow: 0 20px 50px rgba(20, 32, 51, 0.16);
}

.login-form h2 {
  margin: 0 0 22px;
}

.login-form .el-button {
  width: 100%;
}

.hint {
  margin-top: 14px;
  color: #7a8699;
  font-size: 13px;
}

@media (max-width: 820px) {
  .login {
    grid-template-columns: 1fr;
    padding: 30px;
  }

  .login-copy h1 {
    font-size: 32px;
  }
}
</style>
