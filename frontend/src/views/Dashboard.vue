<template>
  <div class="page">
    <div class="metric-grid">
      <div class="metric" v-for="item in metrics" :key="item.label">
        <div class="metric-label">{{ item.label }}</div>
        <div class="metric-value">{{ item.value }}</div>
      </div>
    </div>
    <div class="panel">
      <div class="toolbar">
        <h3>模型效果对比</h3>
        <el-button :icon="Refresh" @click="load">刷新</el-button>
      </div>
      <div ref="chartRef" class="chart"></div>
    </div>
    <div class="panel">
      <h3>最近任务</h3>
      <el-table :data="overview.recentTasks || []" stripe>
        <el-table-column prop="task_name" label="任务名称" />
        <el-table-column prop="task_mode" label="任务模式" width="150" />
        <el-table-column prop="algorithm_type" label="算法" width="170" />
        <el-table-column prop="status" label="状态" width="120" />
        <el-table-column prop="created_at" label="创建时间" width="180" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { computed, nextTick, onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import { Refresh } from '@element-plus/icons-vue'
import { dashboardApi } from '../api'

const overview = ref({})
const chartRef = ref()
let chart

const metrics = computed(() => [
  { label: '机构数量', value: overview.value.orgCount ?? 0 },
  { label: '数据资产', value: overview.value.assetCount ?? 0 },
  { label: '建模任务', value: overview.value.taskCount ?? 0 },
  { label: '运行中任务', value: overview.value.runningTaskCount ?? 0 },
  { label: '任务成功率', value: `${Number(overview.value.successRate || 0) * 100}%` }
])

async function load() {
  const res = await dashboardApi.overview()
  overview.value = res.data
  await nextTick()
  chart ||= echarts.init(chartRef.value)
  const data = overview.value.modelCompare || []
  chart.setOption({
    tooltip: {},
    legend: { top: 0 },
    grid: { left: 36, right: 20, bottom: 32, top: 44 },
    xAxis: { type: 'category', data: data.map((x) => x.task_name || '暂无任务') },
    yAxis: { type: 'value', min: 0, max: 1 },
    series: [
      { name: 'AUC', type: 'bar', data: data.map((x) => x.auc || 0), itemStyle: { color: '#2563eb' } },
      { name: 'KS', type: 'bar', data: data.map((x) => x.ks || 0), itemStyle: { color: '#0f9f6e' } }
    ]
  })
}

onMounted(load)
</script>
