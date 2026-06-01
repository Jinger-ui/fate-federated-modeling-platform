<template>
  <div class="page">
    <div class="toolbar">
      <h3>模型评估报告</h3>
      <el-button :icon="Refresh" @click="load">刷新</el-button>
    </div>
    <div class="panel">
      <el-table :data="rows" stripe @row-click="draw">
        <el-table-column prop="task_name" label="任务名称" />
        <el-table-column prop="algorithm_type" label="算法" width="170" />
        <el-table-column prop="accuracy" label="Accuracy" width="110" />
        <el-table-column prop="precision_rate" label="Precision" width="110" />
        <el-table-column prop="recall_rate" label="Recall" width="110" />
        <el-table-column prop="f1_score" label="F1" width="100" />
        <el-table-column prop="auc" label="AUC" width="100" />
        <el-table-column prop="ks" label="KS" width="100" />
        <el-table-column prop="loss" label="Loss" width="100" />
      </el-table>
    </div>
    <div class="panel">
      <h3>指标对比</h3>
      <div ref="chartRef" class="chart"></div>
    </div>
  </div>
</template>

<script setup>
import { nextTick, onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import { Refresh } from '@element-plus/icons-vue'
import { reportApi } from '../api'

const rows = ref([])
const chartRef = ref()
let chart

async function load() {
  rows.value = (await reportApi.list()).data
  await nextTick()
  draw()
}

function draw() {
  chart ||= echarts.init(chartRef.value)
  chart.setOption({
    tooltip: {},
    legend: {},
    radar: { indicator: ['Accuracy', 'Precision', 'Recall', 'F1', 'AUC', 'KS'].map((name) => ({ name, max: 1 })) },
    series: [{ type: 'radar', data: rows.value.slice(0, 3).map((r) => ({ name: r.task_name, value: [r.accuracy, r.precision_rate, r.recall_rate, r.f1_score, r.auc, r.ks] })) }]
  })
}

onMounted(load)
</script>
