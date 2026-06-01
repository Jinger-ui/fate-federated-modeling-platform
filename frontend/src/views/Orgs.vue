<template>
  <div class="page">
    <div class="toolbar">
      <h3>机构管理</h3>
      <el-button type="primary" :icon="Plus" @click="dialog = true">新增机构</el-button>
    </div>
    <div class="panel">
      <el-table :data="rows" stripe>
        <el-table-column prop="org_code" label="机构编码" width="160" />
        <el-table-column prop="org_name" label="机构名称" />
        <el-table-column prop="org_type" label="类型" width="130" />
        <el-table-column prop="party_id" label="Party ID" width="130" />
        <el-table-column prop="contact_person" label="联系人" width="140" />
        <el-table-column prop="status" label="状态" width="100" />
      </el-table>
    </div>
    <el-dialog v-model="dialog" title="新增机构" width="520px">
      <el-form :model="form" label-width="90px">
        <el-form-item label="编码"><el-input v-model="form.orgCode" /></el-form-item>
        <el-form-item label="名称"><el-input v-model="form.orgName" /></el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.orgType"><el-option label="银行" value="BANK" /><el-option label="运营商" value="OPERATOR" /></el-select>
        </el-form-item>
        <el-form-item label="Party ID"><el-input v-model="form.partyId" /></el-form-item>
        <el-form-item label="联系人"><el-input v-model="form.contactPerson" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialog=false">取消</el-button><el-button type="primary" @click="save">保存</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import { orgApi } from '../api'

const rows = ref([])
const dialog = ref(false)
const form = reactive({ orgCode: '', orgName: '', orgType: 'BANK', partyId: '', contactPerson: '' })

async function load() { rows.value = (await orgApi.list()).data }
async function save() { await orgApi.create(form); dialog.value = false; await load() }
onMounted(load)
</script>
