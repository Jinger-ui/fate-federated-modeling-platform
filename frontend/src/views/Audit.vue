<template>
  <div class="page">
    <div class="toolbar">
      <h3>审计日志</h3>
      <el-button :icon="Refresh" @click="load">刷新</el-button>
    </div>
    <div class="panel">
      <el-tabs>
        <el-tab-pane label="操作日志">
          <el-table :data="logs" stripe>
            <el-table-column prop="username" label="用户" width="130" />
            <el-table-column prop="module_name" label="模块" width="120" />
            <el-table-column prop="operation_type" label="操作" width="110" />
            <el-table-column prop="request_uri" label="路径" />
            <el-table-column prop="success_flag" label="结果" width="90" />
            <el-table-column prop="cost_ms" label="耗时(ms)" width="110" />
            <el-table-column prop="created_at" label="时间" width="180" />
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="登录日志">
          <el-table :data="loginLogs" stripe>
            <el-table-column prop="username" label="用户" />
            <el-table-column prop="success_flag" label="是否成功" />
            <el-table-column prop="failure_reason" label="失败原因" />
            <el-table-column prop="ip" label="IP" />
            <el-table-column prop="created_at" label="时间" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { Refresh } from '@element-plus/icons-vue'
import { auditApi } from '../api'

const logs = ref([])
const loginLogs = ref([])
async function load() {
  logs.value = (await auditApi.logs()).data
  loginLogs.value = (await auditApi.loginLogs()).data
}
onMounted(load)
</script>
