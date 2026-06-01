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

export const defaultExperimentDesigns = [
  {
    experiment_code: 'E1',
    experiment_name: '银行单方基线',
    data_scope: '银行特征',
    algorithm_plan: 'LR / XGBoost',
    experiment_purpose: '验证银行自身数据在信用风险预测中的基础效果，作为单方模型基线。'
  },
  {
    experiment_code: 'E2',
    experiment_name: '运营商特征离线分析',
    data_scope: '运营商特征 + 对齐标签',
    algorithm_plan: 'LR / XGBoost',
    experiment_purpose: '分析运营商行为特征对风险识别的独立贡献，为联邦增益解释提供依据。'
  },
  {
    experiment_code: 'E3',
    experiment_name: '纵向联邦线性模型',
    data_scope: '银行 + 运营商',
    algorithm_plan: 'PSI + Hetero LR',
    experiment_purpose: '验证纵向联邦学习在原始数据不出域条件下联合建模的可行性和可解释性。'
  },
  {
    experiment_code: 'E4',
    experiment_name: '纵向联邦树模型',
    data_scope: '银行 + 运营商',
    algorithm_plan: 'PSI + Hetero SecureBoost',
    experiment_purpose: '验证非线性树模型在风控表格数据上的效果增强能力。'
  },
  {
    experiment_code: 'E5',
    experiment_name: '运营商特征消融实验',
    data_scope: '银行 + 部分运营商特征',
    algorithm_plan: 'PSI + Hetero SecureBoost',
    experiment_purpose: '按消费能力、稳定性、履约行为、活跃度逐组加入运营商特征，分析不同特征组对 AUC、KS、Recall 的增益。'
  }
]

export const defaultFeatureGroups = [
  {
    group_code: 'BANK_BASE',
    group_name: '银行基础信用特征组',
    feature_columns: 'age,credit_score,loan_amount,is_overdue',
    business_meaning: '刻画用户基础信息、信用评分、贷款规模和逾期标签，是信用风险建模的基础特征。',
    ablation_group: 'A组',
    ablation_purpose: '只使用银行特征，作为消融实验基线。'
  },
  {
    group_code: 'OPERATOR_CONSUMPTION',
    group_name: '消费能力特征组',
    feature_columns: 'monthly_fee,package_type',
    business_meaning: '月套餐消费与套餐类型反映用户消费能力和支付能力。',
    ablation_group: 'B组',
    ablation_purpose: '银行特征 + 消费能力特征，验证消费能力信息增益。'
  },
  {
    group_code: 'OPERATOR_STABILITY',
    group_name: '稳定性特征组',
    feature_columns: 'online_months,number_stability',
    business_meaning: '在网时长和号码稳定性反映用户身份稳定性与长期使用行为。',
    ablation_group: 'C组',
    ablation_purpose: '银行特征 + 稳定性特征，验证在网时长、号码稳定性贡献。'
  },
  {
    group_code: 'OPERATOR_PAYMENT_BEHAVIOR',
    group_name: '履约行为特征组',
    feature_columns: 'arrears_count,payment_delay_days',
    business_meaning: '欠费次数与缴费延迟天数反映通信账单履约习惯，与信用违约风险相关。',
    ablation_group: 'D组',
    ablation_purpose: '银行特征 + 欠费履约特征，验证履约行为对风险识别的贡献。'
  },
  {
    group_code: 'OPERATOR_ACTIVITY',
    group_name: '活跃度特征组',
    feature_columns: 'data_usage,call_duration,active_days',
    business_meaning: '流量、通话时长和活跃天数反映用户通信活跃程度与真实使用质量。',
    ablation_group: '扩展组',
    ablation_purpose: '用于进一步解释通信活跃度对模型效果的影响。'
  },
  {
    group_code: 'OPERATOR_ALL',
    group_name: '全部运营商特征组',
    feature_columns: 'monthly_fee,package_type,online_months,number_stability,arrears_count,payment_delay_days,data_usage,call_duration,active_days',
    business_meaning: '汇总运营商消费能力、稳定性、履约行为和活跃度特征，形成联邦联合模型完整特征空间。',
    ablation_group: 'E组',
    ablation_purpose: '银行特征 + 全部运营商特征，作为联邦联合模型完整实验。'
  }
]

export const defaultScenarios = [
  {
    scenario_code: 'LOAN_PRE_DEFAULT_RISK',
    scenario_name: '贷前违约风险评估',
    participant_types: '银行机构,运营商机构',
    data_distribution: 'VERTICAL',
    label_owner: '银行机构',
    recommended_federated_type: '纵向联邦学习',
    recommended_algorithms: 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST',
    recommended_metrics: 'AUC,KS,Recall,F1-score,Loss',
    need_psi: 1,
    business_goal: '预测用户申请贷款后是否存在违约风险。银行和运营商有共同用户但特征不同，银行有标签，运营商无标签，适合纵向联邦。',
    main_scene: true
  },
  {
    scenario_code: 'FRAUD_DETECTION_EXT',
    scenario_name: '反欺诈识别',
    participant_types: '银行机构,支付平台,运营商机构',
    data_distribution: 'VERTICAL',
    label_owner: '银行或支付平台',
    recommended_federated_type: '纵向联邦学习',
    recommended_algorithms: 'PSI_INTERSECTION,HETERO_SECUREBOOST',
    recommended_metrics: 'AUC,PR-AUC,Recall,Precision,Recall@TopK',
    need_psi: 1,
    business_goal: '识别异常申请贷款、异常开户、异常交易用户。欺诈特征通常是非线性和规则组合型，因此 Hetero SecureBoost 更适合作为主模型。',
    main_scene: false
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

export const defaultScenarioDataParams = [
  {
    scenario_code: 'LOAN_PRE_DEFAULT_RISK',
    party_type: '银行机构',
    party_role: 'GUEST',
    label_owner: 1,
    label_definition: '申请贷款后是否逾期/违约，is_overdue: 0/1',
    data_fields: 'user_id,age,income_level,credit_score,loan_amount,loan_term,repay_history,is_overdue',
    feature_groups: '基础信息,信用记录,贷款记录,违约标签',
    data_description: '银行持有用户基础信息、信用记录、贷款申请记录和违约标签，是贷前风险评估的标签方。',
    sample_relation: '与运营商通过 user_id/手机号 hash 后进行 PSI 样本对齐',
    privacy_note: '平台仅保存资产元数据与任务结果，不保存银行原始样本和明文用户 ID。'
  },
  {
    scenario_code: 'LOAN_PRE_DEFAULT_RISK',
    party_type: '运营商机构',
    party_role: 'HOST',
    label_owner: 0,
    label_definition: '无标签',
    data_fields: 'user_id,monthly_fee,package_type,online_months,number_stability,arrears_count,payment_delay_days,data_usage,call_duration,active_days',
    feature_groups: '消费能力,稳定性,履约行为,活跃度',
    data_description: '运营商持有通信消费、在网稳定性、欠费履约和活跃度特征，用于补充银行侧信用信息。',
    sample_relation: '与银行侧共同用户对齐后参与纵向联邦训练',
    privacy_note: '运营商原始通信行为数据不出运营商域。'
  },
  {
    scenario_code: 'FRAUD_DETECTION_EXT',
    party_type: '银行机构',
    party_role: 'GUEST',
    label_owner: 1,
    label_definition: '是否异常申请/欺诈交易，fraud_label: 0/1',
    data_fields: 'user_id,transaction_count,night_trade_count,account_status,device_bind_count,loan_apply_count,fraud_label',
    feature_groups: '交易频次,账户状态,欺诈标签',
    data_description: '银行提供交易频次、账户状态、申请行为和欺诈标签，用于定义反欺诈监督学习目标。',
    sample_relation: '与运营商、电商/支付平台通过 PSI 对齐共同用户',
    privacy_note: '交易流水和账户状态仅保留在银行本地。'
  },
  {
    scenario_code: 'FRAUD_DETECTION_EXT',
    party_type: '运营商机构',
    party_role: 'HOST',
    label_owner: 0,
    label_definition: '无标签',
    data_fields: 'user_id,online_months,arrears_count,device_abnormal_count,number_stability,sim_change_count',
    feature_groups: '号码稳定性,欠费记录,设备异常',
    data_description: '运营商提供手机号在网时长、欠费记录、设备异常和号码稳定性，辅助识别短期异常号和高风险设备行为。',
    sample_relation: '作为纵向联邦 host 参与多方特征联合',
    privacy_note: '号码和设备相关数据不出运营商域。'
  },
  {
    scenario_code: 'FRAUD_DETECTION_EXT',
    party_type: '电商/支付平台',
    party_role: 'HOST',
    label_owner: 0,
    label_definition: '无标签或弱标签',
    data_fields: 'user_id,address_change_count,pay_device_count,trade_frequency,refund_count,night_active_ratio',
    feature_groups: '地址变化,支付设备,交易频率',
    data_description: '电商/支付平台提供地址变更、支付设备、交易频率和退款行为等场景化欺诈特征。',
    sample_relation: '与银行、运营商共同用户进行多 host 纵向联邦',
    privacy_note: '平台仅接收特征元数据和模型指标，不接收支付明细原文。'
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
