<template>
  <div class="page engine-page">
    <div class="hero panel">
      <div>
        <p class="eyebrow">Federated Computing Engine</p>
        <h2>FATE 引擎与算法体系</h2>
        <p class="hero-text">
          平台将 FATE 作为底层联邦计算引擎，后端统一封装 Flow、Pipeline、算法适配和指标解析能力，
          前端通过任务化、模板化、可视化方式完成联合建模。
        </p>
      </div>
      <el-button type="primary" :icon="Refresh" @click="load">刷新模板</el-button>
    </div>

    <div class="metric-grid">
      <div class="metric" v-for="item in metrics" :key="item.label">
        <div class="metric-label">{{ item.label }}</div>
        <div class="metric-value">{{ item.value }}</div>
      </div>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>FATE 引擎层</h3>
        <el-tag type="success">Flow + Pipeline + Adapter</el-tag>
      </div>
      <el-steps :active="components.length" finish-status="success" align-center>
        <el-step
          v-for="item in components"
          :key="item.component_code"
          :title="item.component_name"
          :description="item.layer_type"
        />
      </el-steps>
      <el-table :data="components" stripe class="mt">
        <el-table-column prop="component_name" label="组件" width="180" />
        <el-table-column prop="layer_type" label="层级" width="170" />
        <el-table-column prop="capability" label="能力说明" />
        <el-table-column prop="implementation_ref" label="实现引用" width="220" />
      </el-table>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>算法模板库</h3>
        <el-select v-model="category" clearable placeholder="按算法类型筛选" style="width: 260px" @change="loadAlgorithms">
          <el-option v-for="item in categories" :key="item" :label="item" :value="item" />
        </el-select>
      </div>
      <el-table :data="algorithms" stripe>
        <el-table-column prop="algorithm_name" label="算法" min-width="210" />
        <el-table-column prop="algorithm_category" label="类别" width="190" />
        <el-table-column prop="federated_type" label="联邦类型" width="120" />
        <el-table-column prop="task_target" label="任务目标" width="160" />
        <el-table-column prop="explainability_level" label="解释性" width="100" />
        <el-table-column label="PSI" width="80">
          <template #default="{ row }">
            <el-tag :type="row.need_psi ? 'warning' : 'info'">{{ row.need_psi ? '需要' : '不需要' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="applicable_scenarios" label="适用场景" min-width="260" />
      </el-table>
    </div>

    <div class="panel">
      <h3>业务场景模板</h3>
      <el-row :gutter="14">
        <el-col v-for="item in scenarios" :key="item.scenario_code" :xs="24" :md="12">
          <div class="scenario-card">
            <div class="scenario-title">{{ item.scenario_name }}</div>
            <p>{{ item.business_goal }}</p>
            <div class="tag-line">
              <el-tag>{{ item.data_distribution }}</el-tag>
              <el-tag type="success">{{ item.recommended_federated_type }}</el-tag>
              <el-tag :type="item.need_psi ? 'warning' : 'info'">{{ item.need_psi ? '需要 PSI' : '无需 PSI' }}</el-tag>
            </div>
            <el-descriptions :column="1" size="small" border>
              <el-descriptions-item label="参与方">{{ item.participant_types }}</el-descriptions-item>
              <el-descriptions-item label="标签方">{{ item.label_owner }}</el-descriptions-item>
              <el-descriptions-item label="推荐算法">{{ item.recommended_algorithms }}</el-descriptions-item>
              <el-descriptions-item label="评价指标">{{ item.recommended_metrics }}</el-descriptions-item>
            </el-descriptions>
          </div>
        </el-col>
      </el-row>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>算法推荐策略</h3>
        <el-button type="primary" @click="recommend">生成推荐</el-button>
      </div>
      <el-form :model="recommendForm" label-width="120px" class="recommend-form">
        <el-form-item label="数据分布">
          <el-select v-model="recommendForm.dataDistribution">
            <el-option label="纵向：相同用户不同特征" value="VERTICAL" />
            <el-option label="横向：相同字段不同样本" value="HORIZONTAL" />
          </el-select>
        </el-form-item>
        <el-form-item label="任务目标">
          <el-select v-model="recommendForm.taskTarget">
            <el-option label="二分类：违约/欺诈/流失" value="BINARY_CLASSIFICATION" />
            <el-option label="连续值：金额/额度/评分" value="REGRESSION" />
            <el-option label="次数预测" value="COUNT_REGRESSION" />
          </el-select>
        </el-form-item>
        <el-form-item label="业务偏好">
          <el-checkbox v-model="recommendForm.nonlinear">非线性强</el-checkbox>
          <el-checkbox v-model="recommendForm.explainability">需要可解释性</el-checkbox>
          <el-checkbox v-model="recommendForm.lowOverlap">样本重叠少</el-checkbox>
        </el-form-item>
      </el-form>
      <div v-if="recommendResult.recommendedAlgorithms" class="recommend-result">
        <el-alert title="推荐结果" type="success" :closable="false" />
        <div class="tag-line">
          <el-tag v-for="algo in recommendResult.recommendedAlgorithms" :key="algo.algorithm_code" size="large">
            {{ algo.algorithm_name }}
          </el-tag>
        </div>
        <ul>
          <li v-for="reason in recommendResult.reasons" :key="reason">{{ reason }}</li>
        </ul>
      </div>
      <el-table :data="rules" stripe class="mt">
        <el-table-column prop="condition_desc" label="条件" />
        <el-table-column prop="recommended_algorithm" label="推荐算法" width="260" />
        <el-table-column prop="reason" label="推荐原因" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { Refresh } from '@element-plus/icons-vue'
import { fateEngineApi } from '../api'

const components = ref([])
const algorithms = ref([])
const allAlgorithms = ref([])
const scenarios = ref([])
const rules = ref([])
const category = ref('')
const recommendResult = ref({})
const recommendForm = reactive({
  dataDistribution: 'VERTICAL',
  taskTarget: 'BINARY_CLASSIFICATION',
  nonlinear: true,
  explainability: true,
  lowOverlap: false
})

const categories = computed(() => [...new Set(allAlgorithms.value.map((item) => item.algorithm_category))])
const metrics = computed(() => [
  { label: '引擎组件', value: components.value.length },
  { label: '算法模板', value: allAlgorithms.value.length },
  { label: '场景模板', value: scenarios.value.length },
  { label: '推荐规则', value: rules.value.length }
])

async function loadAlgorithms() {
  algorithms.value = category.value
    ? (await fateEngineApi.algorithms({ category: category.value })).data
    : allAlgorithms.value
}

async function recommend() {
  recommendResult.value = (await fateEngineApi.recommend(recommendForm)).data
}

async function load() {
  const [componentRes, algorithmRes, scenarioRes, ruleRes] = await Promise.all([
    fateEngineApi.components(),
    fateEngineApi.algorithms(),
    fateEngineApi.scenarios(),
    fateEngineApi.rules()
  ])
  components.value = componentRes.data
  allAlgorithms.value = algorithmRes.data
  algorithms.value = algorithmRes.data
  scenarios.value = scenarioRes.data
  rules.value = ruleRes.data
  await recommend()
}

onMounted(load)
</script>

<style scoped>
.hero {
  display: flex;
  justify-content: space-between;
  gap: 24px;
  align-items: center;
  background:
    radial-gradient(circle at 20% 10%, rgba(14, 165, 233, 0.18), transparent 32%),
    linear-gradient(135deg, #ffffff 0%, #eef8ff 100%);
}

.eyebrow {
  margin: 0 0 8px;
  color: #0f766e;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.hero h2 {
  margin: 0;
  font-size: 28px;
}

.hero-text {
  max-width: 860px;
  color: #5b677a;
  line-height: 1.7;
}

.mt {
  margin-top: 16px;
}

.scenario-card {
  min-height: 260px;
  margin-bottom: 14px;
  padding: 16px;
  border: 1px solid #e5ebf4;
  border-radius: 10px;
  background: #fbfdff;
}

.scenario-title {
  font-size: 17px;
  font-weight: 700;
}

.scenario-card p {
  color: #5b677a;
  line-height: 1.6;
}

.tag-line {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 12px 0;
}

.recommend-form {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 8px 20px;
}

.recommend-result {
  margin: 12px 0;
}
</style>
