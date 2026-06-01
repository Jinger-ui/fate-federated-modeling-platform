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
      <el-alert v-if="usingFallback" title="当前使用内置模板兜底展示；后端模板接口恢复后会自动展示数据库内容。" type="warning" show-icon :closable="false" class="mb" />
      <el-steps :active="components.length" finish-status="success" align-center>
        <el-step
          v-for="item in components"
          :key="item.component_code"
          :title="item.component_name"
          :description="item.layer_type"
        />
      </el-steps>
      <el-table :data="components" stripe class="mt" empty-text="暂无引擎组件模板">
        <el-table-column prop="component_name" label="组件" width="180" />
        <el-table-column prop="layer_type" label="层级" width="170" />
        <el-table-column prop="capability" label="能力说明" />
        <el-table-column prop="implementation_ref" label="实现引用" width="220" />
      </el-table>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>四层算法梯度</h3>
        <el-tag type="warning">单方模型 vs 联邦线性模型 vs 联邦树模型</el-tag>
      </div>
      <el-row :gutter="14">
        <el-col v-for="item in layers" :key="item.layer_code" :xs="24" :md="12">
          <div class="layer-card">
            <div class="layer-index">Layer {{ item.layer_level }}</div>
            <div class="scenario-title">{{ item.layer_name }}</div>
            <p class="muted">{{ item.model_family }}</p>
            <el-descriptions :column="1" size="small" border>
              <el-descriptions-item label="算法组合">{{ item.algorithms }}</el-descriptions-item>
              <el-descriptions-item label="实验定位">{{ item.experiment_role }}</el-descriptions-item>
              <el-descriptions-item label="实现范围">{{ item.implementation_scope }}</el-descriptions-item>
              <el-descriptions-item label="对比价值">{{ item.comparison_value }}</el-descriptions-item>
            </el-descriptions>
          </div>
        </el-col>
      </el-row>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>E1-E5 实验矩阵</h3>
        <el-tag type="success">重点：E5 消融实验</el-tag>
      </div>
      <el-table :data="experimentDesigns" stripe empty-text="暂无实验设计">
        <el-table-column prop="experiment_code" label="实验编号" width="100" />
        <el-table-column prop="experiment_name" label="实验名称" min-width="170" />
        <el-table-column prop="data_scope" label="数据" min-width="170" />
        <el-table-column prop="algorithm_plan" label="算法" min-width="190" />
        <el-table-column prop="experiment_purpose" label="目的" min-width="320" />
      </el-table>
      <el-alert class="mt" type="success" :closable="false" show-icon>
        <template #title>
          E5 通过逐组加入运营商特征，分析消费能力、稳定性、履约行为、活跃度对 AUC、KS、Recall 的边际贡献，是论文结果分析中最有解释力的实验。
        </template>
      </el-alert>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>算法模板库</h3>
        <el-select v-model="category" clearable placeholder="按算法类型筛选" style="width: 260px" @change="loadAlgorithms">
          <el-option v-for="item in categories" :key="item" :label="item" :value="item" />
        </el-select>
      </div>
      <el-table :data="algorithms" stripe empty-text="暂无算法模板">
        <el-table-column prop="algorithm_name" label="算法" min-width="210" />
        <el-table-column prop="algorithm_category" label="类别" width="190" />
        <el-table-column prop="federated_type" label="联邦类型" width="120" />
        <el-table-column prop="task_target" label="任务目标" width="160" />
        <el-table-column prop="explainability_level" label="解释性" width="100" />
        <el-table-column prop="metrics" label="重点指标" min-width="220" />
        <el-table-column label="PSI" width="80">
          <template #default="{ row }">
            <el-tag :type="row.need_psi ? 'warning' : 'info'">{{ row.need_psi ? '需要' : '不需要' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="applicable_scenarios" label="适用场景" min-width="260" />
      </el-table>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>特征分组与消融实验</h3>
        <el-tag type="warning">A组到E组逐步加入运营商特征</el-tag>
      </div>
      <el-table :data="featureGroups" stripe empty-text="暂无特征分组">
        <el-table-column prop="ablation_group" label="实验组" width="90" />
        <el-table-column prop="group_name" label="特征组" min-width="170" />
        <el-table-column prop="feature_columns" label="使用特征" min-width="280" />
        <el-table-column prop="business_meaning" label="业务含义" min-width="260" />
        <el-table-column prop="ablation_purpose" label="消融目的" min-width="260" />
      </el-table>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>风控特征工程流水线</h3>
        <el-tag>AUC + KS + Recall 优先</el-tag>
      </div>
      <el-timeline>
        <el-timeline-item
          v-for="item in featureSteps"
          :key="item.step_code"
          :timestamp="`${item.step_order}. ${item.stage_type}`"
        >
          <div class="step-card">
            <strong>{{ item.step_name }}</strong>
            <p>{{ item.method_desc }}</p>
            <div class="tag-line">
              <el-tag size="small" type="info">{{ item.target_fields }}</el-tag>
              <el-tag v-if="item.fate_component_ref" size="small" type="success">{{ item.fate_component_ref }}</el-tag>
              <el-tag v-if="item.implementation_scope" size="small" type="warning">{{ item.implementation_scope }}</el-tag>
            </div>
          </div>
        </el-timeline-item>
      </el-timeline>
    </div>

    <div class="panel">
      <div class="toolbar">
        <h3>模型输出到业务策略</h3>
        <el-tag type="danger">违约概率 -> 风险等级 -> 审批动作</el-tag>
      </div>
      <el-table :data="riskThresholds" stripe empty-text="暂无风险阈值策略">
        <el-table-column prop="strategy_name" label="策略" min-width="170" />
        <el-table-column label="违约概率" width="150">
          <template #default="{ row }">
            {{ formatProbability(row.min_probability) }} ≤ p &lt; {{ formatProbability(row.max_probability) }}
          </template>
        </el-table-column>
        <el-table-column prop="risk_level" label="风险等级" width="110" />
        <el-table-column prop="risk_score_range" label="风险评分" width="120" />
        <el-table-column prop="business_action" label="业务动作" width="140" />
        <el-table-column prop="review_policy" label="复核策略" min-width="260" />
      </el-table>
      <el-alert class="mt" type="info" :closable="false" show-icon>
        <template #title>
          信用风险任务中，高风险用户通常是少数类，因此核心评价指标优先关注 AUC、KS、Recall、Precision、F1、PR-AUC 和 Recall@TopK，Accuracy 仅作为辅助参考。
        </template>
      </el-alert>
    </div>

    <div class="panel">
      <h3>业务场景模板</h3>
      <el-row :gutter="14">
        <el-empty v-if="!scenarios.length" description="暂无场景模板" />
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
      <el-table :data="rules" stripe class="mt" empty-text="暂无推荐规则">
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
import {
  defaultAlgorithmLayers,
  defaultAlgorithms,
  defaultEngineComponents,
  defaultExperimentDesigns,
  defaultFeatureGroups,
  defaultFeatureSteps,
  defaultRiskThresholds,
  defaultRules,
  defaultScenarios
} from '../constants/fateTemplates'

const components = ref([])
const layers = ref([])
const algorithms = ref([])
const allAlgorithms = ref([])
const experimentDesigns = ref([])
const featureGroups = ref([])
const featureSteps = ref([])
const riskThresholds = ref([])
const scenarios = ref([])
const rules = ref([])
const category = ref('')
const recommendResult = ref({})
const usingFallback = ref(false)
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
  { label: '算法梯度', value: layers.value.length },
  { label: '实验矩阵', value: experimentDesigns.value.length },
  { label: '特征分组', value: featureGroups.value.length },
  { label: '算法模板', value: allAlgorithms.value.length },
  { label: '特征工程', value: featureSteps.value.length },
  { label: '风险策略', value: riskThresholds.value.length },
  { label: '场景模板', value: scenarios.value.length },
  { label: '推荐规则', value: rules.value.length }
])

async function loadAlgorithms() {
  if (!category.value) {
    algorithms.value = allAlgorithms.value.length ? allAlgorithms.value : defaultAlgorithms
    return
  }
  try {
    const data = (await fateEngineApi.algorithms({ category: category.value })).data
    algorithms.value = data.length ? data : defaultAlgorithms.filter((item) => item.algorithm_category === category.value)
  } catch {
    algorithms.value = defaultAlgorithms.filter((item) => item.algorithm_category === category.value)
    usingFallback.value = true
  }
}

async function recommend() {
  try {
    recommendResult.value = (await fateEngineApi.recommend(recommendForm)).data
  } catch {
    const preferred = recommendForm.explainability ? 'HETERO_LR' : 'HETERO_SECUREBOOST'
    recommendResult.value = {
      recommendedAlgorithms: defaultAlgorithms.filter((item) => [preferred, 'HETERO_SECUREBOOST'].includes(item.algorithm_code)),
      reasons: ['接口暂不可用，已根据内置规则提供兜底推荐。'],
      needPsi: recommendForm.dataDistribution === 'VERTICAL'
    }
    usingFallback.value = true
  }
}

async function load() {
  usingFallback.value = false
  const [componentRes, layerRes, experimentRes, groupRes, algorithmRes, featureRes, thresholdRes, scenarioRes, ruleRes] = await Promise.allSettled([
    safeRequest('components'),
    safeRequest('layers'),
    safeRequest('experimentDesigns'),
    safeRequest('featureGroups'),
    safeRequest('algorithms'),
    safeRequest('featureSteps'),
    safeRequest('riskThresholds'),
    safeRequest('scenarios'),
    safeRequest('rules')
  ])
  components.value = valueOrFallback(componentRes, defaultEngineComponents)
  layers.value = valueOrFallback(layerRes, defaultAlgorithmLayers)
  experimentDesigns.value = valueOrFallback(experimentRes, defaultExperimentDesigns)
  featureGroups.value = valueOrFallback(groupRes, defaultFeatureGroups)
  allAlgorithms.value = valueOrFallback(algorithmRes, defaultAlgorithms)
  algorithms.value = allAlgorithms.value
  featureSteps.value = valueOrFallback(featureRes, defaultFeatureSteps)
  riskThresholds.value = valueOrFallback(thresholdRes, defaultRiskThresholds)
  scenarios.value = valueOrFallback(scenarioRes, defaultScenarios)
  rules.value = valueOrFallback(ruleRes, defaultRules)
  usingFallback.value = [componentRes, layerRes, experimentRes, groupRes, algorithmRes, featureRes, thresholdRes, scenarioRes, ruleRes].some((item) => item.status !== 'fulfilled')
    || !components.value.length
    || !layers.value.length
    || !experimentDesigns.value.length
    || !featureGroups.value.length
    || !allAlgorithms.value.length
    || !featureSteps.value.length
    || !riskThresholds.value.length
    || !scenarios.value.length
    || !rules.value.length
  await recommend()
}

function safeRequest(methodName) {
  return typeof fateEngineApi[methodName] === 'function'
    ? fateEngineApi[methodName]()
    : Promise.resolve({ data: [] })
}

function valueOrFallback(result, fallback) {
  const data = result.status === 'fulfilled' ? result.value.data : []
  return Array.isArray(data) && data.length ? data : fallback
}

function formatProbability(value) {
  return Number(value || 0).toFixed(2)
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

.mb {
  margin-bottom: 16px;
}

.scenario-card {
  min-height: 260px;
  margin-bottom: 14px;
  padding: 16px;
  border: 1px solid #e5ebf4;
  border-radius: 10px;
  background: #fbfdff;
}

.layer-card,
.step-card {
  margin-bottom: 14px;
  padding: 16px;
  border: 1px solid #dbeafe;
  border-radius: 12px;
  background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
}

.layer-index {
  display: inline-flex;
  margin-bottom: 8px;
  padding: 4px 10px;
  border-radius: 999px;
  color: #0369a1;
  background: #e0f2fe;
  font-size: 12px;
  font-weight: 700;
}

.muted {
  color: #68758a;
}

.step-card p {
  margin: 8px 0;
  color: #5b677a;
  line-height: 1.6;
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
