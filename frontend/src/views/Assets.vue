<template>
  <div class="page">
    <div class="toolbar">
      <h3>数据资产管理</h3>
      <el-button type="primary" :icon="Plus" @click="dialog = true">登记数据资产</el-button>
    </div>
    <div class="panel">
      <el-table :data="rows" stripe @row-click="showDetail">
        <el-table-column prop="asset_code" label="资产编码" width="170" />
        <el-table-column prop="asset_name" label="资产名称" />
        <el-table-column prop="org_name" label="所属机构" width="160" />
        <el-table-column prop="source_type" label="来源" width="120" />
        <el-table-column prop="sample_count" label="样本量" width="120" />
        <el-table-column prop="status" label="状态" width="100" />
      </el-table>
    </div>
    <el-drawer v-model="drawer" title="字段信息" size="520px">
      <el-table :data="detail.fields || []">
        <el-table-column prop="field_name" label="字段名" />
        <el-table-column prop="field_type" label="类型" />
        <el-table-column prop="field_role" label="角色" />
      </el-table>
    </el-drawer>
    <el-dialog v-model="dialog" title="登记数据资产" width="560px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="资产编码"><el-input v-model="form.assetCode" /></el-form-item>
        <el-form-item label="资产名称"><el-input v-model="form.assetName" /></el-form-item>
        <el-form-item label="机构ID"><el-input-number v-model="form.orgId" :min="1" /></el-form-item>
        <el-form-item label="源引用"><el-input v-model="form.sourceRef" /></el-form-item>
        <el-form-item label="主键字段"><el-input v-model="form.idField" /></el-form-item>
        <el-form-item label="标签字段"><el-input v-model="form.labelField" /></el-form-item>
        <el-form-item label="样本量"><el-input-number v-model="form.sampleCount" :min="0" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialog=false">取消</el-button><el-button type="primary" @click="save">保存</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import { assetApi } from '../api'

const rows = ref([])
const dialog = ref(false)
const drawer = ref(false)
const detail = ref({})
const form = reactive({ assetCode: '', assetName: '', orgId: 1, sourceType: 'FATE_TABLE', sourceRef: '', idField: 'user_id', labelField: '', sampleCount: 1000 })

async function load() { rows.value = (await assetApi.list()).data }
async function save() { await assetApi.create(form); dialog.value = false; await load() }
async function showDetail(row) { detail.value = (await assetApi.detail(row.id)).data; drawer.value = true }
onMounted(load)
</script>
