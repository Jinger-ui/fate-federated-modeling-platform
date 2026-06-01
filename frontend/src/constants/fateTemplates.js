export const defaultEngineComponents = [
  {
    component_code: 'FATE_CORE',
    component_name: 'FATE Core',
    layer_type: 'ENGINE',
    capability: '提供联邦学习算法组件、隐私计算协议和多方协同计算能力，是平台底层联邦计算内核。',
    implementation_ref: 'FATE Standalone / Cluster'
  },
  {
    component_code: 'FATE_FLOW',
    component_name: 'FATE Flow',
    layer_type: 'ORCHESTRATION',
    capability: '负责任务提交、调度、状态查询、资源协调、日志追踪、模型管理和指标查询。',
    implementation_ref: 'Flow API / flow command'
  },
  {
    component_code: 'FATE_PIPELINE',
    component_name: 'FATE Pipeline',
    layer_type: 'DAG_BUILDER',
    capability: '构建联邦学习任务 DAG，串联 Reader、Intersection、Transform、Train、Evaluation 等组件。',
    implementation_ref: 'pipeline Python SDK'
  },
  {
    component_code: 'ALGORITHM_ADAPTER',
    component_name: 'Algorithm Adapter',
    layer_type: 'PLATFORM_ADAPTER',
    capability: '根据业务场景、数据分布和任务目标选择 FATE 算法组件并生成任务参数。',
    implementation_ref: 'Spring Boot service adapter'
  },
  {
    component_code: 'METRIC_PARSER',
    component_name: 'Metric Parser',
    layer_type: 'PLATFORM_ADAPTER',
    capability: '解析 FATE 输出的 Loss、AUC、KS、Accuracy、Precision、Recall、F1 等指标并回写 MySQL。',
    implementation_ref: 'FateFlow metrics parser'
  },
  {
    component_code: 'SCENARIO_TEMPLATE',
    component_name: 'Scenario Template',
    layer_type: 'PLATFORM_TEMPLATE',
    capability: '沉淀信用风险、反欺诈、客户流失、精准营销、医疗预测、保险理赔等典型联邦业务模板。',
    implementation_ref: 'MySQL template metadata'
  }
]

export const defaultAlgorithms = [
  {
    algorithm_code: 'PSI_INTERSECTION',
    algorithm_name: 'PSI / Intersection 样本对齐',
    algorithm_category: 'SAMPLE_ALIGNMENT',
    fate_component: 'Intersection',
    federated_type: 'VERTICAL',
    task_target: 'ID_ALIGNMENT',
    explainability_level: 'MEDIUM',
    need_psi: 0,
    applicable_scenarios: '银行与运营商共同用户对齐；多方共同样本识别'
  },
  {
    algorithm_code: 'HETERO_LR',
    algorithm_name: 'Hetero Logistic Regression',
    algorithm_category: 'VERTICAL_CLASSIFICATION',
    fate_component: 'HeteroLR',
    federated_type: 'VERTICAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'HIGH',
    need_psi: 1,
    applicable_scenarios: '信用风险预测；贷款违约预测；反欺诈识别；风控评分'
  },
  {
    algorithm_code: 'HETERO_SECUREBOOST',
    algorithm_name: 'Hetero SecureBoost',
    algorithm_category: 'VERTICAL_CLASSIFICATION',
    fate_component: 'HeteroSecureBoost',
    federated_type: 'VERTICAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'MEDIUM',
    need_psi: 1,
    applicable_scenarios: '信用风险预测；反欺诈识别；营销转化预测；复杂特征交互建模'
  },
  {
    algorithm_code: 'HOMO_LR',
    algorithm_name: 'Homo Logistic Regression',
    algorithm_category: 'HORIZONTAL_CLASSIFICATION',
    fate_component: 'HomoLR',
    federated_type: 'HORIZONTAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'HIGH',
    need_psi: 0,
    applicable_scenarios: '多家银行拥有相同字段但不同客户样本'
  },
  {
    algorithm_code: 'HOMO_SECUREBOOST',
    algorithm_name: 'Homo SecureBoost',
    algorithm_category: 'HORIZONTAL_CLASSIFICATION',
    fate_component: 'HomoSecureBoost',
    federated_type: 'HORIZONTAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'MEDIUM',
    need_psi: 0,
    applicable_scenarios: '同构特征的跨机构分类建模'
  },
  {
    algorithm_code: 'HETERO_LINEAR_REGRESSION',
    algorithm_name: 'Hetero Linear Regression',
    algorithm_category: 'FEDERATED_REGRESSION',
    fate_component: 'HeteroLinR',
    federated_type: 'VERTICAL',
    task_target: 'REGRESSION',
    explainability_level: 'HIGH',
    need_psi: 1,
    applicable_scenarios: '用户消费金额预测；信贷额度预测；评分预测'
  },
  {
    algorithm_code: 'SECUREBOOST_REGRESSION',
    algorithm_name: 'SecureBoost Regression',
    algorithm_category: 'FEDERATED_REGRESSION',
    fate_component: 'HeteroSecureBoost',
    federated_type: 'VERTICAL',
    task_target: 'REGRESSION',
    explainability_level: 'MEDIUM',
    need_psi: 1,
    applicable_scenarios: '额度预测；收入预测；复杂非线性回归任务'
  },
  {
    algorithm_code: 'POISSON_REGRESSION',
    algorithm_name: 'Poisson Regression',
    algorithm_category: 'FEDERATED_REGRESSION',
    fate_component: 'PoissonRegression',
    federated_type: 'VERTICAL',
    task_target: 'COUNT_REGRESSION',
    explainability_level: 'HIGH',
    need_psi: 1,
    applicable_scenarios: '次数预测；事件频次预测；理赔次数预测'
  },
  {
    algorithm_code: 'FEDERATED_NN',
    algorithm_name: 'Federated Neural Network',
    algorithm_category: 'FEDERATED_DEEP_LEARNING',
    fate_component: 'HeteroNN/HomoNN',
    federated_type: 'MIXED',
    task_target: 'DEEP_LEARNING',
    explainability_level: 'LOW',
    need_psi: 0,
    applicable_scenarios: '复杂特征表达；图像文本多模态；深度模型扩展方向'
  },
  {
    algorithm_code: 'FEDERATED_TRANSFER_LEARNING',
    algorithm_name: 'Federated Transfer Learning',
    algorithm_category: 'TRANSFER_LEARNING',
    fate_component: 'FTL',
    federated_type: 'TRANSFER',
    task_target: 'TRANSFER_LEARNING',
    explainability_level: 'LOW',
    need_psi: 0,
    applicable_scenarios: '样本重叠较少但存在知识迁移需求的场景'
  }
]

export const defaultScenarios = [
  {
    scenario_code: 'BANK_OPERATOR_CREDIT_RISK',
    scenario_name: '银行与运营商信用风险预测',
    participant_types: '银行机构,运营商机构',
    data_distribution: 'VERTICAL',
    label_owner: '银行机构',
    recommended_federated_type: '纵向联邦学习',
    recommended_algorithms: 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST',
    recommended_metrics: 'Accuracy,Precision,Recall,F1,AUC,KS,Loss',
    need_psi: 1,
    business_goal: '在原始数据不出域前提下融合金融信用特征与通信行为特征，预测贷款逾期风险。'
  },
  {
    scenario_code: 'BANK_PAY_OPERATOR_FRAUD',
    scenario_name: '银行、支付平台与运营商反欺诈识别',
    participant_types: '银行机构,支付平台,运营商机构',
    data_distribution: 'VERTICAL',
    label_owner: '银行或支付平台',
    recommended_federated_type: '纵向联邦学习',
    recommended_algorithms: 'PSI_INTERSECTION,HETERO_SECUREBOOST,HETERO_LR',
    recommended_metrics: 'Precision,Recall,F1,AUC,KS',
    need_psi: 1,
    business_goal: '融合交易、账户、通信行为特征识别欺诈交易或异常申请。'
  },
  {
    scenario_code: 'OPERATOR_INTERNET_CHURN',
    scenario_name: '运营商与互联网平台客户流失预测',
    participant_types: '运营商机构,互联网平台',
    data_distribution: 'VERTICAL',
    label_owner: '运营商机构',
    recommended_federated_type: '纵向联邦学习',
    recommended_algorithms: 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST',
    recommended_metrics: 'Accuracy,Recall,F1,AUC,Loss',
    need_psi: 1,
    business_goal: '通过通信行为和互联网活跃特征预测客户流失概率，支撑精细化运营。'
  }
]

export const defaultRules = [
  {
    rule_code: 'RULE_VERTICAL_FEATURE_SPLIT',
    condition_desc: '多方拥有相同用户但不同特征',
    recommended_algorithm: 'HETERO_LR,HETERO_SECUREBOOST',
    reason: '该数据分布符合纵向联邦学习，需先进行 PSI 样本对齐。'
  },
  {
    rule_code: 'RULE_HORIZONTAL_SAMPLE_SPLIT',
    condition_desc: '多方拥有相同字段但不同样本',
    recommended_algorithm: 'HOMO_LR,HOMO_SECUREBOOST',
    reason: '字段结构一致且样本不同，适合横向联邦训练统一模型。'
  },
  {
    rule_code: 'RULE_BINARY_TARGET',
    condition_desc: '任务目标为是否违约、是否欺诈、是否流失',
    recommended_algorithm: 'HETERO_LR,HETERO_SECUREBOOST',
    reason: '二分类风控任务可优先选择逻辑回归基线和 SecureBoost 效果模型。'
  },
  {
    rule_code: 'RULE_EXPLAINABILITY',
    condition_desc: '业务需要较强可解释性',
    recommended_algorithm: 'HETERO_LR',
    reason: '逻辑回归参数可解释性更强，适合作为风控评分基线。'
  }
]
