<template>
  <div class="page">
    <div class="toolbar">
      <h3>样本对齐</h3>
      <el-button type="primary" :icon="Plus" @click="dialog = true">创建 PSI 任务</el-button>
    </div>
    <div class="panel">
      <el-table :data="rows" stripe>
        <el-table-column prop="task_code" label="任务编码" width="190" />
        <el-table-column prop="task_name" label="任务名称" />
        <el-table-column prop="run_mode" label="模式" width="120" />
        <el-table-column prop="intersect_count" label="交集样本量" width="130" />
        <el-table-column prop="status" label="状态" width="110">
          <template #default="{ row }"><el-tag :type="row.status === 'SUCCESS' ? 'success' : 'warning'">{{ row.status }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="finish_time" label="完成时间" width="180" />
      </el-table>
    </div>
    <el-dialog v-model="dialog" title="创建样本对齐任务" width="560px">
      <el-form :model="form" label-width="110px">
        <el-form-item label="任务名称"><el-input v-model="form.taskName" /></el-form-item>
        <el-form-item label="银行机构ID"><el-input-number v-model="form.guestOrgId" :min="1" /></el-form-item>
        <el-form-item label="运营商机构ID"><el-input-number v-model="form.hostOrgId" :min="1" /></el-form-item>
        <el-form-item label="银行资产ID"><el-input-number v-model="form.guestAssetId" :min="1" /></el-form-item>
        <el-form-item label="运营商资产ID"><el-input-number v-model="form.hostAssetId" :min="1" /></el-form-item>
        <el-form-item label="主键字段"><el-input v-model="form.idField" /></el-form-item>
        <el-form-item label="运行模式"><el-select v-model="form.runMode"><el-option label="MOCK" value="MOCK" /></el-select></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialog=false">取消</el-button><el-button type="primary" @click="save">执行</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import { psiApi } from '../api'

const rows = ref([])
const dialog = ref(false)
const form = reactive({ taskName: '银行运营商样本对齐', guestOrgId: 1, hostOrgId: 2, guestAssetId: 1, hostAssetId: 2, idField: 'user_id', runMode: 'MOCK' })

async function load() { rows.value = (await psiApi.list()).data }
async function save() { await psiApi.create(form); dialog.value = false; await load() }
onMounted(load)
</script>
