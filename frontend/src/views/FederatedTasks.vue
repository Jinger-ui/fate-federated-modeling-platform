<template>
  <div class="page">
    <div class="toolbar">
      <h3>联邦建模任务</h3>
      <el-button type="primary" :icon="Plus" @click="dialog = true">创建建模任务</el-button>
    </div>
    <div class="panel">
      <el-table :data="rows" stripe>
        <el-table-column prop="task_code" label="任务编码" width="190" />
        <el-table-column prop="task_name" label="任务名称" />
        <el-table-column prop="algorithm_type" label="算法" width="170" />
        <el-table-column prop="submit_type" label="执行模式" width="130" />
        <el-table-column prop="status" label="状态" width="120">
          <template #default="{ row }"><el-tag :type="tagType(row.status)">{{ row.status }}</el-tag></template>
        </el-table-column>
        <el-table-column label="操作" width="210">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="submit(row)">提交</el-button>
            <el-button size="small" @click="viewRuntime(row)">监控</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-drawer v-model="drawer" title="训练状态监控" size="620px">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="状态">{{ runtime.status }}</el-descriptions-item>
        <el-descriptions-item label="外部 Job ID">{{ runtime.external_job_id }}</el-descriptions-item>
        <el-descriptions-item label="错误信息">{{ runtime.error_msg || '无' }}</el-descriptions-item>
      </el-descriptions>
      <h3>运行日志</h3>
      <el-timeline>
        <el-timeline-item v-for="log in runtime.logs || []" :key="log.id" :timestamp="log.log_time">
          <el-tag size="small">{{ log.log_level }}</el-tag>
          <span class="log-text">{{ log.content }}</span>
        </el-timeline-item>
      </el-timeline>
    </el-drawer>
    <el-dialog v-model="dialog" title="创建联邦建模任务" width="640px">
      <el-form :model="form" label-width="110px">
        <el-form-item label="任务名称"><el-input v-model="form.taskName" /></el-form-item>
        <el-form-item label="任务模式"><el-select v-model="form.taskMode"><el-option label="联邦联合训练" value="FEDERATED" /><el-option label="银行单方训练" value="SINGLE_BANK" /><el-option label="运营商单方训练" value="SINGLE_OPERATOR" /></el-select></el-form-item>
        <el-form-item label="算法">
          <el-select v-model="form.algorithmType" filterable>
            <el-option
              v-for="algo in algorithms"
              :key="algo.algorithm_code"
              :label="algo.algorithm_name"
              :value="algo.algorithm_code"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="PSI任务ID"><el-input-number v-model="form.psiTaskId" :min="1" /></el-form-item>
        <el-form-item label="执行模式"><el-select v-model="form.submitType"><el-option label="MOCK" value="MOCK" /><el-option label="FATE Pipeline" value="FATE_PIPELINE" /><el-option label="FATE Flow API" value="FATE_FLOW_API" /></el-select></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialog=false">取消</el-button><el-button type="primary" @click="save">保存</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ElMessage } from 'element-plus'
import { onMounted, reactive, ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import { fateEngineApi, taskApi } from '../api'

const rows = ref([])
const algorithms = ref([])
const dialog = ref(false)
const drawer = ref(false)
const runtime = ref({})
const form = reactive({
  taskName: '银行运营商联合建模实验',
  taskMode: 'FEDERATED',
  algorithmType: 'HETERO_LR',
  psiTaskId: 1,
  submitType: 'MOCK',
  parties: [
    { orgId: 1, roleType: 'GUEST', assetId: 1, partyId: '9999', hasLabel: 1 },
    { orgId: 2, roleType: 'HOST', assetId: 2, partyId: '10000', hasLabel: 0 }
  ],
  algoParams: { maxIter: 30, learningRate: 0.05, batchSize: 64 }
})

function tagType(status) {
  return status === 'SUCCESS' ? 'success' : status === 'FAILED' ? 'danger' : status === 'RUNNING' ? 'warning' : 'info'
}

async function load() {
  rows.value = (await taskApi.list()).data
  algorithms.value = (await fateEngineApi.algorithms()).data
}
async function save() { await taskApi.create(form); dialog.value = false; await load() }
async function submit(row) { await taskApi.submit(row.id); ElMessage.success('任务已执行'); await load() }
async function viewRuntime(row) { runtime.value = (await taskApi.runtime(row.id)).data; drawer.value = true }
onMounted(load)
</script>

<style scoped>
.log-text {
  margin-left: 8px;
}
</style>
