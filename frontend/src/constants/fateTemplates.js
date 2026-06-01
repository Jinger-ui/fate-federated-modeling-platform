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
    algorithm_name: 'Hetero Logistic Regression（可解释基线模型）',
    algorithm_category: 'VERTICAL_CLASSIFICATION',
    fate_component: 'HeteroLR',
    federated_type: 'VERTICAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'HIGH',
    need_psi: 1,
    metrics: 'AUC,KS,Recall,Precision,F1,Loss,Accuracy',
    applicable_scenarios: '信用风险预测；贷款违约预测；输出风险概率；分析银行与运营商特征权重；作为 SecureBoost 对照组'
  },
  {
    algorithm_code: 'HETERO_SECUREBOOST',
    algorithm_name: 'Hetero SecureBoost（效果增强模型）',
    algorithm_category: 'VERTICAL_CLASSIFICATION',
    fate_component: 'HeteroSecureBoost',
    federated_type: 'VERTICAL',
    task_target: 'BINARY_CLASSIFICATION',
    explainability_level: 'MEDIUM',
    need_psi: 1,
    metrics: 'AUC,KS,Recall,Precision,F1,PR-AUC,Recall@TopK,Loss',
    applicable_scenarios: '信用风险预测；反欺诈识别；营销转化预测；处理非线性特征关系和复杂特征交互'
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

export const defaultAlgorithmLayers = [
  {
    layer_code: 'L1_SINGLE_BASELINE',
    layer_name: '第一层：单方基线模型',
    layer_level: 1,
    model_family: 'Single-party baseline',
    algorithms: '银行单方 LR / XGBoost；运营商单方 LR / XGBoost',
    experiment_role: '建立单方模型效果下限，衡量银行特征与运营商特征各自的信息增益。',
    implementation_scope: '核心实现',
    comparison_value: '作为联邦模型的对照组，形成“单方模型 vs 联邦模型”的基本实验结构。'
  },
  {
    layer_code: 'L2_VERTICAL_BASELINE',
    layer_name: '第二层：纵向联邦基础模型',
    layer_level: 2,
    model_family: 'Vertical federated linear model',
    algorithms: 'PSI + Hetero Logistic Regression',
    experiment_role: '验证多方特征在原始数据不出域条件下联合训练的可行性，并提供可解释基线。',
    implementation_scope: '核心实现',
    comparison_value: '输出风险概率和特征权重，可解释性强，适合作为论文基线算法。'
  },
  {
    layer_code: 'L3_VERTICAL_ENHANCED',
    layer_name: '第三层：纵向联邦增强模型',
    layer_level: 3,
    model_family: 'Vertical federated tree model',
    algorithms: 'PSI + Hetero SecureBoost',
    experiment_role: '处理非线性特征关系与复杂特征交互，提升风控表格数据建模效果。',
    implementation_scope: '核心实现',
    comparison_value: '与 Hetero LR 对比，体现树模型在 AUC、KS、Recall 等指标上的增强能力。'
  },
  {
    layer_code: 'L4_EXTENSION_RESERVED',
    layer_name: '第四层：扩展预留模型',
    layer_level: 4,
    model_family: 'Platform extension algorithms',
    algorithms: 'Homo LR / Homo SecureBoost / Hetero Linear Regression / Federated NN / Transfer Learning',
    experiment_role: '支撑横向联邦、回归任务、深度学习和迁移学习等后续平台扩展方向。',
    implementation_scope: '扩展预留',
    comparison_value: '展示平台算法扩展性，论文中作为展望与系统可演进能力。'
  }
]

export const defaultFeatureSteps = [
  {
    step_code: 'MISSING_VALUE_FILL',
    step_name: '缺失值填充',
    step_order: 10,
    stage_type: 'PREPROCESS',
    target_fields: 'income_level,monthly_fee,data_usage,call_duration',
    method_desc: '对数值字段采用均值/中位数填充，对类别字段采用 unknown 类别填充，降低样本丢失。'
  },
  {
    step_code: 'OUTLIER_CLIP',
    step_name: '异常值处理',
    step_order: 20,
    stage_type: 'PREPROCESS',
    target_fields: 'monthly_fee,data_usage,call_duration,loan_amount',
    method_desc: '使用分位数截断或业务阈值裁剪异常消费、流量、通话和贷款金额。'
  },
  {
    step_code: 'CATEGORY_ENCODING',
    step_name: '类别变量编码',
    step_order: 30,
    stage_type: 'FEATURE_TRANSFORM',
    target_fields: 'package_type,income_level,customer_level',
    method_desc: '对套餐类型、收入等级、客户等级进行 One-Hot 或序号编码。'
  },
  {
    step_code: 'NUMERIC_STANDARDIZE',
    step_name: '数值特征标准化',
    step_order: 40,
    stage_type: 'FEATURE_TRANSFORM',
    target_fields: 'monthly_fee,data_usage,call_duration,credit_score',
    method_desc: '对消费、流量、通话时长、信用评分进行标准化，适配 LR 梯度训练。'
  },
  {
    step_code: 'RISK_FEATURE_BUILD',
    step_name: '风险特征构造',
    step_order: 50,
    stage_type: 'FEATURE_CONSTRUCTION',
    target_fields: 'arrears_count,online_months',
    method_desc: '构造 arrears_count / online_months 等风险强度特征，刻画单位在网时长欠费频率。'
  },
  {
    step_code: 'FEATURE_BINNING',
    step_name: '风控分箱特征',
    step_order: 60,
    stage_type: 'FEATURE_BINNING',
    target_fields: 'credit_score,online_months,loan_amount',
    method_desc: '对信用评分、在网时长、贷款金额分段，增强风控规则解释性与稳定性。'
  },
  {
    step_code: 'IMBALANCE_HANDLING',
    step_name: '类别不平衡处理',
    step_order: 70,
    stage_type: 'TRAINING_STRATEGY',
    target_fields: 'is_overdue,label',
    method_desc: '高风险用户通常为少数类，训练与评估时弱化 Accuracy 依赖，重点关注 AUC、KS、Recall、F1、PR-AUC。'
  }
]

export const defaultRiskThresholds = [
  {
    strategy_code: 'LOW_RISK_PASS',
    strategy_name: '低风险通过策略',
    min_probability: 0,
    max_probability: 0.3,
    risk_level: 'LOW',
    risk_score_range: '700-850',
    business_action: '可通过',
    review_policy: '自动审批或低强度审核'
  },
  {
    strategy_code: 'MEDIUM_RISK_REVIEW',
    strategy_name: '中风险复核策略',
    min_probability: 0.3,
    max_probability: 0.6,
    risk_level: 'MEDIUM',
    risk_score_range: '550-699',
    business_action: '人工复核',
    review_policy: '结合征信、收入与通信稳定性进行补充审核'
  },
  {
    strategy_code: 'HIGH_RISK_REJECT',
    strategy_name: '高风险重点审查策略',
    min_probability: 0.6,
    max_probability: 1,
    risk_level: 'HIGH',
    risk_score_range: '300-549',
    business_action: '拒绝或重点审查',
    review_policy: '进入高风险名单，触发人工复审或拒绝授信'
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
