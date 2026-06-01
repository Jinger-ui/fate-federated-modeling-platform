insert ignore into sys_role(id, role_code, role_name, status) values
  (1, 'ADMIN', '平台管理员', 1),
  (2, 'ORG_USER', '机构操作员', 1),
  (3, 'AUDITOR', '审计员', 1);

insert ignore into org_info(id, org_code, org_name, org_type, party_id, contact_person, contact_phone, status, remark) values
  (1, 'BANK001', '示例银行机构', 'BANK', '9999', '银行负责人', '13800000001', 1, '持有标签与金融特征'),
  (2, 'OPERATOR001', '示例运营商机构', 'OPERATOR', '10000', '运营商负责人', '13800000002', 1, '持有通信行为特征'),
  (3, 'BANK002', '区域商业银行', 'BANK', '10001', '风控负责人', '13800000003', 1, '用于扩展多银行联合建模演示'),
  (4, 'OPERATOR002', '虚拟运营商机构', 'OPERATOR', '10002', '数据负责人', '13800000004', 1, '用于扩展多运营商特征协作演示');

insert ignore into org_node_config(id, org_id, node_host, node_port, data_namespace, fate_version, config_json) values
  (1, 1, 'localhost', 9380, 'bank_credit_risk', 'standalone', json_object('role', 'guest')),
  (2, 2, 'localhost', 9380, 'operator_credit_risk', 'standalone', json_object('role', 'host')),
  (3, 3, 'localhost', 9380, 'regional_bank_credit', 'standalone', json_object('role', 'guest')),
  (4, 4, 'localhost', 9380, 'virtual_operator_credit', 'standalone', json_object('role', 'host'));

insert ignore into data_asset(id, asset_code, asset_name, org_id, asset_type, source_type, source_ref, id_field, label_field, sample_count, status, version_no, created_by) values
  (1, 'BANK_TRAIN_V1', '银行信用风险训练集V1', 1, 'TRAIN', 'FATE_TABLE', 'bank_credit_risk.bank_train_v1', 'user_id', 'is_overdue', 5000, 'VALID', 'v1', 1),
  (2, 'OPERATOR_TRAIN_V1', '运营商通信行为训练集V1', 2, 'TRAIN', 'FATE_TABLE', 'operator_credit_risk.operator_train_v1', 'user_id', null, 6200, 'VALID', 'v1', 1),
  (3, 'BANK_TEST_V1', '银行信用风险测试集V1', 1, 'TEST', 'FATE_TABLE', 'bank_credit_risk.bank_test_v1', 'user_id', 'is_overdue', 1200, 'VALID', 'v1', 1),
  (4, 'OPERATOR_TEST_V1', '运营商通信行为测试集V1', 2, 'TEST', 'FATE_TABLE', 'operator_credit_risk.operator_test_v1', 'user_id', null, 1350, 'VALID', 'v1', 1),
  (5, 'BANK_SINGLE_BASELINE', '银行单方基线实验数据', 1, 'TRAIN', 'MYSQL_TABLE', 'local.bank_baseline_train', 'user_id', 'is_overdue', 5000, 'VALID', 'v1', 1),
  (6, 'OPERATOR_SINGLE_BASELINE', '运营商单方基线实验数据', 2, 'TRAIN', 'MYSQL_TABLE', 'local.operator_baseline_train', 'user_id', 'is_overdue_mock', 5000, 'VALID', 'v1', 1);

insert ignore into data_asset_field(asset_id, field_name, field_type, field_role, nullable_flag, description) values
  (1, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (1, 'age', 'int', 'FEATURE', 1, '年龄'),
  (1, 'credit_score', 'decimal', 'FEATURE', 1, '信用评分'),
  (1, 'loan_amount', 'decimal', 'FEATURE', 1, '贷款金额'),
  (1, 'is_overdue', 'int', 'LABEL', 0, '是否逾期'),
  (2, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (2, 'net_age_months', 'int', 'FEATURE', 1, '在网时长'),
  (2, 'monthly_fee', 'decimal', 'FEATURE', 1, '月套餐消费'),
  (2, 'arrears_count', 'int', 'FEATURE', 1, '欠费次数'),
  (3, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (3, 'age', 'int', 'FEATURE', 1, '年龄'),
  (3, 'credit_score', 'decimal', 'FEATURE', 1, '信用评分'),
  (3, 'loan_amount', 'decimal', 'FEATURE', 1, '贷款金额'),
  (3, 'is_overdue', 'int', 'LABEL', 0, '是否逾期'),
  (4, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (4, 'net_age_months', 'int', 'FEATURE', 1, '在网时长'),
  (4, 'monthly_fee', 'decimal', 'FEATURE', 1, '月套餐消费'),
  (4, 'arrears_count', 'int', 'FEATURE', 1, '欠费次数'),
  (5, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (5, 'age', 'int', 'FEATURE', 1, '年龄'),
  (5, 'credit_score', 'decimal', 'FEATURE', 1, '信用评分'),
  (5, 'loan_amount', 'decimal', 'FEATURE', 1, '贷款金额'),
  (5, 'is_overdue', 'int', 'LABEL', 0, '是否逾期'),
  (6, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (6, 'net_age_months', 'int', 'FEATURE', 1, '在网时长'),
  (6, 'monthly_fee', 'decimal', 'FEATURE', 1, '月套餐消费'),
  (6, 'arrears_count', 'int', 'FEATURE', 1, '欠费次数'),
  (6, 'is_overdue_mock', 'int', 'LABEL', 0, '模拟逾期标签');

insert ignore into psi_task(id, task_code, task_name, guest_org_id, host_org_id, guest_asset_id, host_asset_id, status, run_mode, id_field, submit_time, finish_time, result_ref, intersect_count) values
  (1, 'PSI202606010001', '银行与运营商训练样本对齐', 1, 2, 1, 2, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 09:20:00', '2026-06-01 09:20:08', 'mock://psi/train/intersection', 4680),
  (2, 'PSI202606010002', '银行与运营商测试样本对齐', 1, 2, 3, 4, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 09:32:00', '2026-06-01 09:32:07', 'mock://psi/test/intersection', 1126),
  (3, 'PSI202606010003', '区域银行扩展样本对齐', 3, 4, 5, 6, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 10:05:00', '2026-06-01 10:05:10', 'mock://psi/region/intersection', 3920);

insert ignore into federated_task(id, task_code, task_name, task_mode, algorithm_type, psi_task_id, status, submit_type, external_job_id, created_by, created_at, submit_time, finish_time) values
  (1, 'FT202606010001', '银行单方逻辑回归基线', 'SINGLE_BANK', 'LOGISTIC_REGRESSION', null, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT202606010001', 1, '2026-06-01 09:40:00', '2026-06-01 09:41:00', '2026-06-01 09:41:15'),
  (2, 'FT202606010002', '运营商单方行为特征基线', 'SINGLE_OPERATOR', 'LOGISTIC_REGRESSION', null, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT202606010002', 1, '2026-06-01 09:45:00', '2026-06-01 09:46:00', '2026-06-01 09:46:18'),
  (3, 'FT202606010003', '银行运营商联邦逻辑回归', 'FEDERATED', 'HETERO_LR', 1, 'SUCCESS', 'FATE_PIPELINE', '202606010329149343800', 1, '2026-06-01 10:00:00', '2026-06-01 10:01:00', '2026-06-01 10:03:00'),
  (4, 'FT202606010004', '银行运营商联邦SecureBoost', 'FEDERATED', 'HETERO_SECUREBOOST', 1, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT202606010004', 1, '2026-06-01 10:18:00', '2026-06-01 10:19:00', '2026-06-01 10:19:42'),
  (5, 'FT202606010005', '区域银行扩展联邦实验', 'FEDERATED', 'HETERO_LR', 3, 'RUNNING', 'MOCK', 'MOCK-JOB-FT202606010005', 1, '2026-06-01 10:40:00', '2026-06-01 10:41:00', null);

insert ignore into federated_task_party(id, task_id, org_id, role_type, asset_id, party_id, has_label) values
  (1, 3, 1, 'GUEST', 1, '9999', 1),
  (2, 3, 2, 'HOST', 2, '10000', 0),
  (3, 4, 1, 'GUEST', 1, '9999', 1),
  (4, 4, 2, 'HOST', 2, '10000', 0),
  (5, 5, 3, 'GUEST', 5, '10001', 1),
  (6, 5, 4, 'HOST', 6, '10002', 0);

insert ignore into task_runtime_log(id, task_id, log_level, log_time, content) values
  (1, 3, 'INFO', '2026-06-01 10:01:00', '开始执行 FATE Pipeline：Hetero Logistic Regression'),
  (2, 3, 'INFO', '2026-06-01 10:02:58', 'Job is success!!! Job id is 202606010329149343800'),
  (3, 3, 'INFO', '2026-06-01 10:03:00', 'FATE Pipeline 执行完成，jobId=202606010329149343800'),
  (4, 5, 'INFO', '2026-06-01 10:41:00', '任务已提交，等待训练状态同步');

insert ignore into model_report(id, task_id, report_name, dataset_type, accuracy, precision_rate, recall_rate, f1_score, auc, ks, loss, summary_text) values
  (1, 1, '银行单方模型评估报告', 'TEST', 0.7810, 0.7420, 0.7010, 0.7209, 0.8120, 0.3920, 0.4820, '银行单方模型可作为基线，特征维度有限。'),
  (2, 2, '运营商单方模型评估报告', 'TEST', 0.7420, 0.7100, 0.6680, 0.6884, 0.7760, 0.3410, 0.5230, '运营商行为特征具备一定区分能力。'),
  (3, 3, '联邦逻辑回归评估报告', 'TEST', 0.8640, 0.8280, 0.8010, 0.8143, 0.9030, 0.5340, 0.3240, '联邦模型融合银行与运营商特征，AUC 和 KS 均优于单方基线。'),
  (4, 4, '联邦SecureBoost评估报告', 'TEST', 0.8790, 0.8460, 0.8170, 0.8312, 0.9180, 0.5620, 0.2980, 'SecureBoost 对非线性特征关系表达更强。');

insert ignore into model_curve_data(id, report_id, curve_type, curve_json) values
  (1, 3, 'ROC', '[{"x":0,"y":0},{"x":0.08,"y":0.41},{"x":0.2,"y":0.68},{"x":0.42,"y":0.87},{"x":1,"y":1}]'),
  (2, 3, 'LOSS', '[{"x":1,"y":0.61},{"x":5,"y":0.44},{"x":10,"y":0.36},{"x":20,"y":0.324}]'),
  (3, 4, 'ROC', '[{"x":0,"y":0},{"x":0.06,"y":0.46},{"x":0.18,"y":0.74},{"x":0.38,"y":0.9},{"x":1,"y":1}]'),
  (4, 4, 'LOSS', '[{"x":1,"y":0.58},{"x":5,"y":0.39},{"x":10,"y":0.32},{"x":20,"y":0.298}]');

insert ignore into audit_log(id, user_id, username, org_id, module_name, operation_type, request_uri, request_method, response_code, success_flag, cost_ms, ip, created_at) values
  (1, 1, 'admin', 1, 'PSI', 'POST', '/api/psi/tasks', 'POST', '200', 1, 85, '127.0.0.1', '2026-06-01 09:20:08'),
  (2, 1, 'admin', 1, 'FEDERATED', 'POST', '/api/federated/tasks/3/submit', 'POST', '200', 1, 120000, '127.0.0.1', '2026-06-01 10:03:00'),
  (3, 1, 'admin', 1, 'REPORT', 'GET', '/api/reports/compare', 'GET', '200', 1, 36, '127.0.0.1', '2026-06-01 10:08:00');

insert ignore into psi_task(id, task_code, task_name, guest_org_id, host_org_id, guest_asset_id, host_asset_id, status, run_mode, id_field, submit_time, finish_time, result_ref, intersect_count) values
  (101, 'PSI-DEMO-TRAIN', '银行与运营商训练样本对齐', 1, 2, 1, 2, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 09:20:00', '2026-06-01 09:20:08', 'mock://psi/train/intersection', 4680),
  (102, 'PSI-DEMO-TEST', '银行与运营商测试样本对齐', 1, 2, 3, 4, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 09:32:00', '2026-06-01 09:32:07', 'mock://psi/test/intersection', 1126),
  (103, 'PSI-DEMO-REGION', '区域银行扩展样本对齐', 3, 4, 5, 6, 'SUCCESS', 'MOCK', 'user_id', '2026-06-01 10:05:00', '2026-06-01 10:05:10', 'mock://psi/region/intersection', 3920);

insert ignore into federated_task(id, task_code, task_name, task_mode, algorithm_type, psi_task_id, status, submit_type, external_job_id, created_by, created_at, submit_time, finish_time) values
  (101, 'FT-DEMO-BANK-LR', '银行单方逻辑回归基线', 'SINGLE_BANK', 'LOGISTIC_REGRESSION', null, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT-DEMO-BANK-LR', 1, '2026-06-01 09:40:00', '2026-06-01 09:41:00', '2026-06-01 09:41:15'),
  (102, 'FT-DEMO-OPERATOR-LR', '运营商单方行为特征基线', 'SINGLE_OPERATOR', 'LOGISTIC_REGRESSION', null, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT-DEMO-OPERATOR-LR', 1, '2026-06-01 09:45:00', '2026-06-01 09:46:00', '2026-06-01 09:46:18'),
  (103, 'FT-DEMO-FED-LR', '银行运营商联邦逻辑回归', 'FEDERATED', 'HETERO_LR', 101, 'SUCCESS', 'FATE_PIPELINE', '202606010329149343800', 1, '2026-06-01 10:00:00', '2026-06-01 10:01:00', '2026-06-01 10:03:00'),
  (104, 'FT-DEMO-FED-SBT', '银行运营商联邦SecureBoost', 'FEDERATED', 'HETERO_SECUREBOOST', 101, 'SUCCESS', 'MOCK', 'MOCK-JOB-FT-DEMO-FED-SBT', 1, '2026-06-01 10:18:00', '2026-06-01 10:19:00', '2026-06-01 10:19:42'),
  (105, 'FT-DEMO-REGION-LR', '区域银行扩展联邦实验', 'FEDERATED', 'HETERO_LR', 103, 'RUNNING', 'MOCK', 'MOCK-JOB-FT-DEMO-REGION-LR', 1, '2026-06-01 10:40:00', '2026-06-01 10:41:00', null);

insert ignore into federated_task_party(id, task_id, org_id, role_type, asset_id, party_id, has_label) values
  (101, 103, 1, 'GUEST', 1, '9999', 1),
  (102, 103, 2, 'HOST', 2, '10000', 0),
  (103, 104, 1, 'GUEST', 1, '9999', 1),
  (104, 104, 2, 'HOST', 2, '10000', 0),
  (105, 105, 3, 'GUEST', 5, '10001', 1),
  (106, 105, 4, 'HOST', 6, '10002', 0);

insert ignore into task_runtime_log(id, task_id, log_level, log_time, content) values
  (101, 103, 'INFO', '2026-06-01 10:01:00', '开始执行 FATE Pipeline：Hetero Logistic Regression'),
  (102, 103, 'INFO', '2026-06-01 10:02:58', 'Job is success!!! Job id is 202606010329149343800'),
  (103, 103, 'INFO', '2026-06-01 10:03:00', 'FATE Pipeline 执行完成，jobId=202606010329149343800'),
  (104, 105, 'INFO', '2026-06-01 10:41:00', '任务已提交，等待训练状态同步');

insert ignore into model_report(id, task_id, report_name, dataset_type, accuracy, precision_rate, recall_rate, f1_score, auc, ks, loss, summary_text) values
  (101, 101, '银行单方模型评估报告', 'TEST', 0.7810, 0.7420, 0.7010, 0.7209, 0.8120, 0.3920, 0.4820, '银行单方模型可作为基线，特征维度有限。'),
  (102, 102, '运营商单方模型评估报告', 'TEST', 0.7420, 0.7100, 0.6680, 0.6884, 0.7760, 0.3410, 0.5230, '运营商行为特征具备一定区分能力。'),
  (103, 103, '联邦逻辑回归评估报告', 'TEST', 0.8640, 0.8280, 0.8010, 0.8143, 0.9030, 0.5340, 0.3240, '联邦模型融合银行与运营商特征，AUC 和 KS 均优于单方基线。'),
  (104, 104, '联邦SecureBoost评估报告', 'TEST', 0.8790, 0.8460, 0.8170, 0.8312, 0.9180, 0.5620, 0.2980, 'SecureBoost 对非线性特征关系表达更强。');

insert ignore into model_curve_data(id, report_id, curve_type, curve_json) values
  (101, 103, 'ROC', '[{"x":0,"y":0},{"x":0.08,"y":0.41},{"x":0.2,"y":0.68},{"x":0.42,"y":0.87},{"x":1,"y":1}]'),
  (102, 103, 'LOSS', '[{"x":1,"y":0.61},{"x":5,"y":0.44},{"x":10,"y":0.36},{"x":20,"y":0.324}]'),
  (103, 104, 'ROC', '[{"x":0,"y":0},{"x":0.06,"y":0.46},{"x":0.18,"y":0.74},{"x":0.38,"y":0.9},{"x":1,"y":1}]'),
  (104, 104, 'LOSS', '[{"x":1,"y":0.58},{"x":5,"y":0.39},{"x":10,"y":0.32},{"x":20,"y":0.298}]');

insert ignore into fate_engine_component(id, component_code, component_name, layer_type, capability, implementation_ref, sort_no) values
  (1, 'FATE_CORE', 'FATE Core', 'ENGINE', '提供联邦学习算法组件、隐私计算协议和多方协同计算能力，是平台底层联邦计算内核。', 'FATE Standalone / Cluster', 10),
  (2, 'FATE_FLOW', 'FATE Flow', 'ORCHESTRATION', '负责任务提交、调度、状态查询、资源协调、日志追踪、模型管理和指标查询。', 'Flow API / flow command', 20),
  (3, 'FATE_PIPELINE', 'FATE Pipeline', 'DAG_BUILDER', '构建联邦学习任务 DAG，串联 Reader、Intersection、Transform、Train、Evaluation 等组件。', 'pipeline Python SDK', 30),
  (4, 'ALGORITHM_ADAPTER', 'Algorithm Adapter', 'PLATFORM_ADAPTER', '根据业务场景、数据分布和任务目标选择 FATE 算法组件并生成任务参数。', 'Spring Boot service adapter', 40),
  (5, 'METRIC_PARSER', 'Metric Parser', 'PLATFORM_ADAPTER', '解析 FATE 输出的 Loss、AUC、KS、Accuracy、Precision、Recall、F1 等指标并回写 MySQL。', 'FateFlow metrics parser', 50),
  (6, 'SCENARIO_TEMPLATE', 'Scenario Template', 'PLATFORM_TEMPLATE', '沉淀信用风险、反欺诈、客户流失、精准营销、医疗预测、保险理赔等典型联邦业务模板。', 'MySQL template metadata', 60);

insert ignore into federated_algorithm_template(id, algorithm_code, algorithm_name, algorithm_category, fate_component, federated_type, task_target, explainability_level, nonlinear_support, need_psi, metrics, applicable_scenarios, extension_flag, default_params, sort_no) values
  (1, 'PSI_INTERSECTION', 'PSI / Intersection 样本对齐', 'SAMPLE_ALIGNMENT', 'Intersection', 'VERTICAL', 'ID_ALIGNMENT', 'MEDIUM', 0, 0, 'intersect_count,match_rate', '银行与运营商共同用户对齐；多方共同样本识别', 0, json_object('intersect_method','rsa','sync_intersect_ids',false), 10),
  (2, 'HETERO_LR', 'Hetero Logistic Regression（可解释基线模型）', 'VERTICAL_CLASSIFICATION', 'HeteroLR', 'VERTICAL', 'BINARY_CLASSIFICATION', 'HIGH', 0, 1, 'AUC,KS,Recall,Precision,F1,Loss,Accuracy', '信用风险预测；贷款违约预测；输出风险概率；分析银行与运营商特征权重；作为 SecureBoost 对照组', 0, json_object('max_iter',30,'learning_rate',0.05,'batch_size',64), 20),
  (3, 'HETERO_SECUREBOOST', 'Hetero SecureBoost（效果增强模型）', 'VERTICAL_CLASSIFICATION', 'HeteroSecureBoost', 'VERTICAL', 'BINARY_CLASSIFICATION', 'MEDIUM', 1, 1, 'AUC,KS,Recall,Precision,F1,PR-AUC,Recall@TopK,Loss', '信用风险预测；反欺诈识别；营销转化预测；处理非线性特征关系和复杂特征交互', 0, json_object('num_trees',50,'max_depth',4,'learning_rate',0.1), 30),
  (4, 'HOMO_LR', 'Homo Logistic Regression', 'HORIZONTAL_CLASSIFICATION', 'HomoLR', 'HORIZONTAL', 'BINARY_CLASSIFICATION', 'HIGH', 0, 0, 'Accuracy,Precision,Recall,F1,AUC,Loss', '多家银行拥有相同字段但不同客户样本', 1, json_object('max_iter',30,'learning_rate',0.05), 40),
  (5, 'HOMO_SECUREBOOST', 'Homo SecureBoost', 'HORIZONTAL_CLASSIFICATION', 'HomoSecureBoost', 'HORIZONTAL', 'BINARY_CLASSIFICATION', 'MEDIUM', 1, 0, 'Accuracy,Precision,Recall,F1,AUC,Loss', '同构特征的跨机构分类建模', 1, json_object('num_trees',50,'max_depth',4), 50),
  (6, 'HETERO_LINEAR_REGRESSION', 'Hetero Linear Regression', 'FEDERATED_REGRESSION', 'HeteroLinR', 'VERTICAL', 'REGRESSION', 'HIGH', 0, 1, 'MAE,MSE,RMSE,R2,Loss', '用户消费金额预测；信贷额度预测；评分预测', 1, json_object('max_iter',30,'learning_rate',0.05), 60),
  (7, 'SECUREBOOST_REGRESSION', 'SecureBoost Regression', 'FEDERATED_REGRESSION', 'HeteroSecureBoost', 'VERTICAL', 'REGRESSION', 'MEDIUM', 1, 1, 'MAE,MSE,RMSE,R2,Loss', '额度预测；收入预测；复杂非线性回归任务', 1, json_object('objective','regression','num_trees',50,'max_depth',4), 70),
  (8, 'POISSON_REGRESSION', 'Poisson Regression', 'FEDERATED_REGRESSION', 'PoissonRegression', 'VERTICAL', 'COUNT_REGRESSION', 'HIGH', 0, 1, 'MAE,MSE,Deviance,Loss', '次数预测；事件频次预测；理赔次数预测', 1, json_object('max_iter',30,'learning_rate',0.05), 80),
  (9, 'FEDERATED_NN', 'Federated Neural Network', 'FEDERATED_DEEP_LEARNING', 'HeteroNN/HomoNN', 'MIXED', 'DEEP_LEARNING', 'LOW', 1, 0, 'Accuracy,AUC,Loss', '复杂特征表达；图像文本多模态；深度模型扩展方向', 1, json_object('epochs',10,'batch_size',128), 90),
  (10, 'FEDERATED_TRANSFER_LEARNING', 'Federated Transfer Learning', 'TRANSFER_LEARNING', 'FTL', 'TRANSFER', 'TRANSFER_LEARNING', 'LOW', 1, 0, 'Accuracy,AUC,Loss', '样本重叠较少但存在知识迁移需求的场景', 1, json_object('epochs',10,'overlap_ratio','low'), 100);

update federated_algorithm_template
set algorithm_name='Hetero Logistic Regression（可解释基线模型）',
    metrics='AUC,KS,Recall,Precision,F1,Loss,Accuracy',
    applicable_scenarios='信用风险预测；贷款违约预测；输出风险概率；分析银行与运营商特征权重；作为 SecureBoost 对照组'
where algorithm_code='HETERO_LR';

update federated_algorithm_template
set algorithm_name='Hetero SecureBoost（效果增强模型）',
    metrics='AUC,KS,Recall,Precision,F1,PR-AUC,Recall@TopK,Loss',
    applicable_scenarios='信用风险预测；反欺诈识别；营销转化预测；处理非线性特征关系和复杂特征交互'
where algorithm_code='HETERO_SECUREBOOST';

insert ignore into algorithm_experiment_layer(id, layer_code, layer_name, layer_level, model_family, algorithms, experiment_role, implementation_scope, comparison_value) values
  (1, 'L1_SINGLE_BASELINE', '第一层：单方基线模型', 1, 'Single-party baseline', '银行单方 LR / XGBoost；运营商单方 LR / XGBoost', '建立单方模型效果下限，衡量银行特征与运营商特征各自的信息增益。', '核心实现', '作为联邦模型的对照组，形成“单方模型 vs 联邦模型”的基本实验结构。'),
  (2, 'L2_VERTICAL_BASELINE', '第二层：纵向联邦基础模型', 2, 'Vertical federated linear model', 'PSI + Hetero Logistic Regression', '验证多方特征在原始数据不出域条件下联合训练的可行性，并提供可解释基线。', '核心实现', '输出风险概率和特征权重，可解释性强，适合作为论文基线算法。'),
  (3, 'L3_VERTICAL_ENHANCED', '第三层：纵向联邦增强模型', 3, 'Vertical federated tree model', 'PSI + Hetero SecureBoost', '处理非线性特征关系与复杂特征交互，提升风控表格数据建模效果。', '核心实现', '与 Hetero LR 对比，体现树模型在 AUC、KS、Recall 等指标上的增强能力。'),
  (4, 'L4_EXTENSION_RESERVED', '第四层：扩展预留模型', 4, 'Platform extension algorithms', 'Homo LR / Homo SecureBoost / Hetero Linear Regression / Federated NN / Transfer Learning', '支撑横向联邦、回归任务、深度学习和迁移学习等后续平台扩展方向。', '扩展预留', '展示平台算法扩展性，论文中作为展望与系统可演进能力。');

insert ignore into feature_engineering_step(id, step_code, step_name, step_order, stage_type, target_fields, method_desc, fate_component_ref, implementation_scope) values
  (1, 'MISSING_VALUE_FILL', '缺失值填充', 10, 'PREPROCESS', 'income_level,monthly_fee,data_usage,call_duration', '对数值字段采用均值/中位数填充，对类别字段采用 unknown 类别填充，降低样本丢失。', 'DataTransform / local preprocessing', '模拟数据与预处理阶段实现'),
  (2, 'OUTLIER_CLIP', '异常值处理', 20, 'PREPROCESS', 'monthly_fee,data_usage,call_duration,loan_amount', '使用分位数截断或业务阈值裁剪异常消费、流量、通话和贷款金额。', 'DataTransform / local preprocessing', '模拟数据与预处理阶段实现'),
  (3, 'CATEGORY_ENCODING', '类别变量编码', 30, 'FEATURE_TRANSFORM', 'package_type,income_level,customer_level', '对套餐类型、收入等级、客户等级进行 One-Hot 或序号编码。', 'DataTransform', '平台参数预留'),
  (4, 'NUMERIC_STANDARDIZE', '数值特征标准化', 40, 'FEATURE_TRANSFORM', 'monthly_fee,data_usage,call_duration,credit_score', '对消费、流量、通话时长、信用评分进行标准化，适配 LR 梯度训练。', 'Scale / DataTransform', 'Hetero LR 推荐启用'),
  (5, 'RISK_FEATURE_BUILD', '风险特征构造', 50, 'FEATURE_CONSTRUCTION', 'arrears_count,online_months', '构造 arrears_count / online_months 等风险强度特征，刻画单位在网时长欠费频率。', 'local feature script', '模拟数据与预处理阶段实现'),
  (6, 'FEATURE_BINNING', '风控分箱特征', 60, 'FEATURE_BINNING', 'credit_score,online_months,loan_amount', '对信用评分、在网时长、贷款金额分段，增强风控规则解释性与稳定性。', 'FeatureBinning', '平台参数预留'),
  (7, 'IMBALANCE_HANDLING', '类别不平衡处理', 70, 'TRAINING_STRATEGY', 'is_overdue,label', '高风险用户通常为少数类，训练与评估时弱化 Accuracy 依赖，重点关注 AUC、KS、Recall、F1、PR-AUC。', 'Evaluation / sample weight', '实验评价重点实现');

insert ignore into risk_threshold_strategy(id, strategy_code, strategy_name, min_probability, max_probability, risk_level, risk_score_range, business_action, review_policy) values
  (1, 'LOW_RISK_PASS', '低风险通过策略', 0.0000, 0.3000, 'LOW', '700-850', '可通过', '自动审批或低强度审核'),
  (2, 'MEDIUM_RISK_REVIEW', '中风险复核策略', 0.3000, 0.6000, 'MEDIUM', '550-699', '人工复核', '结合征信、收入与通信稳定性进行补充审核'),
  (3, 'HIGH_RISK_REJECT', '高风险重点审查策略', 0.6000, 1.0000, 'HIGH', '300-549', '拒绝或重点审查', '进入高风险名单，触发人工复审或拒绝授信');

insert ignore into experiment_design_template(id, experiment_code, experiment_name, data_scope, algorithm_plan, experiment_purpose, baseline_flag, core_flag, sort_no) values
  (1, 'E1', '银行单方基线', '银行特征', 'LR / XGBoost', '验证银行自身数据在信用风险预测中的基础效果，作为单方模型基线。', 1, 1, 10),
  (2, 'E2', '运营商特征离线分析', '运营商特征 + 对齐标签', 'LR / XGBoost', '分析运营商行为特征对风险识别的独立贡献，为联邦增益解释提供依据。', 1, 1, 20),
  (3, 'E3', '纵向联邦线性模型', '银行 + 运营商', 'PSI + Hetero LR', '验证纵向联邦学习在原始数据不出域条件下联合建模的可行性和可解释性。', 0, 1, 30),
  (4, 'E4', '纵向联邦树模型', '银行 + 运营商', 'PSI + Hetero SecureBoost', '验证非线性树模型在风控表格数据上的效果增强能力。', 0, 1, 40),
  (5, 'E5', '运营商特征消融实验', '银行 + 部分运营商特征', 'PSI + Hetero SecureBoost', '按消费能力、稳定性、履约行为、活跃度逐组加入运营商特征，分析不同特征组对 AUC、KS、Recall 的增益。', 0, 1, 50);

insert ignore into feature_group(id, dataset_id, group_code, group_name, feature_columns, business_meaning, ablation_group, ablation_purpose, sort_no) values
  (1, 1, 'BANK_BASE', '银行基础信用特征组', 'age,credit_score,loan_amount,is_overdue', '刻画用户基础信息、信用评分、贷款规模和逾期标签，是信用风险建模的基础特征。', 'A组', '只使用银行特征，作为消融实验基线。', 10),
  (2, 2, 'OPERATOR_CONSUMPTION', '消费能力特征组', 'monthly_fee,package_type', '月套餐消费与套餐类型反映用户消费能力和支付能力。', 'B组', '银行特征 + 消费能力特征，验证消费能力信息增益。', 20),
  (3, 2, 'OPERATOR_STABILITY', '稳定性特征组', 'online_months,number_stability', '在网时长和号码稳定性反映用户身份稳定性与长期使用行为。', 'C组', '银行特征 + 稳定性特征，验证在网时长、号码稳定性贡献。', 30),
  (4, 2, 'OPERATOR_PAYMENT_BEHAVIOR', '履约行为特征组', 'arrears_count,payment_delay_days', '欠费次数与缴费延迟天数反映通信账单履约习惯，与信用违约风险相关。', 'D组', '银行特征 + 欠费履约特征，验证履约行为对风险识别的贡献。', 40),
  (5, 2, 'OPERATOR_ACTIVITY', '活跃度特征组', 'data_usage,call_duration,active_days', '流量、通话时长和活跃天数反映用户通信活跃程度与真实使用质量。', '扩展组', '用于进一步解释通信活跃度对模型效果的影响。', 50),
  (6, 2, 'OPERATOR_ALL', '全部运营商特征组', 'monthly_fee,package_type,online_months,number_stability,arrears_count,payment_delay_days,data_usage,call_duration,active_days', '汇总运营商消费能力、稳定性、履约行为和活跃度特征，形成联邦联合模型完整特征空间。', 'E组', '银行特征 + 全部运营商特征，作为联邦联合模型完整实验。', 60);

insert ignore into algorithm_template(id, algorithm_code, algorithm_name, federated_type, task_type, need_psi, need_label_owner, support_multi_host, default_params, default_metrics, status) values
  (1, 'HETERO_LR', 'Hetero Logistic Regression', 'VERTICAL', 'BINARY_CLASSIFICATION', 1, 1, 1, json_object('max_iter',30,'learning_rate',0.05,'batch_size',64), 'AUC,KS,Recall,Precision,F1,Loss', 'ENABLED'),
  (2, 'HETERO_SECUREBOOST', 'Hetero SecureBoost', 'VERTICAL', 'BINARY_CLASSIFICATION', 1, 1, 1, json_object('num_trees',50,'max_depth',4,'learning_rate',0.1), 'AUC,KS,Recall,Precision,F1,PR-AUC,Recall@TopK', 'ENABLED'),
  (3, 'HOMO_LR', 'Homo Logistic Regression', 'HORIZONTAL', 'BINARY_CLASSIFICATION', 0, 1, 1, json_object('max_iter',30,'learning_rate',0.05), 'AUC,Recall,F1,Loss', 'RESERVED'),
  (4, 'HETERO_LINEAR_REGRESSION', 'Hetero Linear Regression', 'VERTICAL', 'REGRESSION', 1, 1, 1, json_object('max_iter',30,'learning_rate',0.05), 'MAE,MSE,RMSE,R2,Loss', 'RESERVED');

insert ignore into scenario_template(id, scenario_code, scenario_name, industry, task_type, label_definition, recommended_algorithm, recommended_metrics, description, status) values
  (1, 'CREDIT_DEFAULT_RISK', '信用违约风险预测', '金融风控', 'BINARY_CLASSIFICATION', '是否发生贷款逾期或违约', 'HETERO_LR,HETERO_SECUREBOOST', 'AUC,KS,Recall,Precision,F1,Loss', '银行与运营商在原始数据不出域条件下联合预测信用违约风险。', 'ENABLED'),
  (2, 'FRAUD_DETECTION', '反欺诈识别', '金融安全', 'BINARY_CLASSIFICATION', '是否为欺诈交易或欺诈申请', 'HETERO_SECUREBOOST,HETERO_LR', 'Precision,Recall,F1,AUC,KS,PR-AUC', '融合账户、交易、通信行为识别欺诈风险。', 'RESERVED'),
  (3, 'CUSTOMER_CHURN', '客户流失预测', '运营商', 'BINARY_CLASSIFICATION', '是否在观察窗口内流失', 'HETERO_LR,HETERO_SECUREBOOST', 'AUC,Recall,F1,Loss', '结合通信行为和平台活跃特征预测客户流失概率。', 'RESERVED'),
  (4, 'MARKETING_CONVERSION', '营销转化预测', '精准营销', 'BINARY_CLASSIFICATION', '是否响应营销活动或完成转化', 'HETERO_SECUREBOOST', 'AUC,Precision,Recall,Recall@TopK', '通过多方特征提升高潜客识别能力。', 'RESERVED'),
  (5, 'CREDIT_LIMIT_REGRESSION', '信贷额度预测', '金融风控', 'REGRESSION', '可授信额度或额度调整值', 'HETERO_LINEAR_REGRESSION,SECUREBOOST_REGRESSION', 'MAE,MSE,RMSE,R2,Loss', '扩展连续值预测能力，使平台不局限于二分类任务。', 'RESERVED');

insert ignore into business_scenario_template(id, scenario_code, scenario_name, participant_types, data_distribution, label_owner, recommended_federated_type, recommended_algorithms, recommended_metrics, need_psi, business_goal, sort_no) values
  (1, 'LOAN_PRE_DEFAULT_RISK', '贷前违约风险评估', '银行机构,运营商机构', 'VERTICAL', '银行机构', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST', 'AUC,KS,Recall,F1-score,Loss', 1, '预测用户申请贷款后是否存在违约风险。银行和运营商拥有共同用户但特征不同，银行持有违约标签，运营商不持有标签，适合纵向联邦。', 10),
  (2, 'FRAUD_DETECTION_EXT', '反欺诈识别', '银行机构,运营商机构,电商/支付平台', 'VERTICAL', '银行或支付平台', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_SECUREBOOST', 'AUC,PR-AUC,Recall,Precision,Recall@TopK', 1, '识别异常申请贷款、异常开户、异常交易用户。欺诈特征通常是非线性和规则组合型，树模型更适合作为主模型。', 20),
  (3, 'OPERATOR_INTERNET_CHURN', '运营商与互联网平台客户流失预测', '运营商机构,互联网平台', 'VERTICAL', '运营商机构', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST', 'Accuracy,Recall,F1,AUC,Loss', 1, '通过通信行为和互联网活跃特征预测客户流失概率，支撑精细化运营。', 30),
  (4, 'MULTI_BANK_HOMO_RISK', '多银行同构信用风险联合建模', '商业银行,区域银行,消费金融机构', 'HORIZONTAL', '各参与银行', '横向联邦学习', 'HOMO_LR,HOMO_SECUREBOOST', 'Accuracy,Precision,Recall,F1,AUC,Loss', 0, '多家银行字段结构一致但样本不同，通过横向联邦提升模型泛化能力。', 40);

update business_scenario_template
set scenario_code='LOAN_PRE_DEFAULT_RISK',
    scenario_name='贷前违约风险评估',
    participant_types='银行机构,运营商机构',
    data_distribution='VERTICAL',
    label_owner='银行机构',
    recommended_federated_type='纵向联邦学习',
    recommended_algorithms='PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST',
    recommended_metrics='AUC,KS,Recall,F1-score,Loss',
    need_psi=1,
    business_goal='预测用户申请贷款后是否存在违约风险。银行和运营商拥有共同用户但特征不同，银行持有违约标签，运营商不持有标签，适合纵向联邦。',
    sort_no=10
where id=1;

update business_scenario_template
set scenario_code='FRAUD_DETECTION_EXT',
    scenario_name='反欺诈识别',
    participant_types='银行机构,运营商机构,电商/支付平台',
    data_distribution='VERTICAL',
    label_owner='银行或支付平台',
    recommended_federated_type='纵向联邦学习',
    recommended_algorithms='PSI_INTERSECTION,HETERO_SECUREBOOST',
    recommended_metrics='AUC,PR-AUC,Recall,Precision,Recall@TopK',
    need_psi=1,
    business_goal='识别异常申请贷款、异常开户、异常交易用户。欺诈特征通常是非线性和规则组合型，树模型更适合作为主模型。',
    sort_no=20
where id=2;

insert ignore into scenario_data_param(id, scenario_code, party_type, party_role, label_owner, label_definition, data_fields, feature_groups, data_description, sample_relation, privacy_note, sort_no) values
  (1, 'LOAN_PRE_DEFAULT_RISK', '银行机构', 'GUEST', 1, '申请贷款后是否逾期/违约，is_overdue: 0/1', 'user_id,age,income_level,credit_score,loan_amount,loan_term,repay_history,is_overdue', '基础信息,信用记录,贷款记录,违约标签', '银行持有用户基础信息、信用记录、贷款申请记录和违约标签，是贷前风险评估的标签方。', '与运营商通过 user_id/手机号 hash 后进行 PSI 样本对齐', '平台仅保存资产元数据与任务结果，不保存银行原始样本和明文用户 ID。', 10),
  (2, 'LOAN_PRE_DEFAULT_RISK', '运营商机构', 'HOST', 0, '无标签', 'user_id,monthly_fee,package_type,online_months,number_stability,arrears_count,payment_delay_days,data_usage,call_duration,active_days', '消费能力,稳定性,履约行为,活跃度', '运营商持有通信消费、在网稳定性、欠费履约和活跃度特征，用于补充银行侧信用信息。', '与银行侧共同用户对齐后参与纵向联邦训练', '运营商原始通信行为数据不出域，仅在 FATE 组件中参与加密计算。', 20),
  (3, 'FRAUD_DETECTION_EXT', '银行机构', 'GUEST', 1, '是否异常申请/欺诈交易，fraud_label: 0/1', 'user_id,transaction_count,night_trade_count,account_status,device_bind_count,loan_apply_count,fraud_label', '交易频次,账户状态,欺诈标签', '银行提供交易频次、账户状态、申请行为和欺诈标签，用于定义反欺诈监督学习目标。', '与运营商、电商/支付平台通过 PSI 对齐共同用户', '交易流水和账户状态仅保留在银行本地。', 10),
  (4, 'FRAUD_DETECTION_EXT', '运营商机构', 'HOST', 0, '无标签', 'user_id,online_months,arrears_count,device_abnormal_count,number_stability,sim_change_count', '号码稳定性,欠费记录,设备异常', '运营商提供手机号在网时长、欠费记录、设备异常和号码稳定性，辅助识别短期异常号和高风险设备行为。', '作为纵向联邦 host 参与多方特征联合', '号码和设备相关数据不出运营商域。', 20),
  (5, 'FRAUD_DETECTION_EXT', '电商/支付平台', 'HOST', 0, '无标签或弱标签', 'user_id,address_change_count,pay_device_count,trade_frequency,refund_count,night_active_ratio', '地址变化,支付设备,交易频率', '电商/支付平台提供地址变更、支付设备、交易频率和退款行为等场景化欺诈特征。', '与银行、运营商共同用户进行多 host 纵向联邦', '平台仅接收特征元数据和模型指标，不接收支付明细原文。', 30);

insert ignore into algorithm_recommend_rule(id, rule_code, condition_desc, recommended_type, recommended_algorithm, reason, priority) values
  (1, 'RULE_VERTICAL_FEATURE_SPLIT', '多方拥有相同用户但不同特征', 'VERTICAL', 'HETERO_LR,HETERO_SECUREBOOST', '该数据分布符合纵向联邦学习，需先进行 PSI 样本对齐。', 100),
  (2, 'RULE_HORIZONTAL_SAMPLE_SPLIT', '多方拥有相同字段但不同样本', 'HORIZONTAL', 'HOMO_LR,HOMO_SECUREBOOST', '字段结构一致且样本不同，适合横向联邦训练统一模型。', 90),
  (3, 'RULE_BINARY_TARGET', '任务目标为是否违约、是否欺诈、是否流失', 'CLASSIFICATION', 'HETERO_LR,HETERO_SECUREBOOST', '二分类风控任务可优先选择逻辑回归基线和 SecureBoost 效果模型。', 80),
  (4, 'RULE_CONTINUOUS_TARGET', '任务目标为金额、额度、评分等连续值', 'REGRESSION', 'HETERO_LINEAR_REGRESSION,SECUREBOOST_REGRESSION', '连续值预测适合联邦回归算法或树模型回归目标。', 70),
  (5, 'RULE_COUNT_TARGET', '任务目标为次数预测', 'COUNT_REGRESSION', 'POISSON_REGRESSION,SECUREBOOST_REGRESSION', '计数型目标可考虑 Poisson Regression 或回归类树模型。', 60),
  (6, 'RULE_NONLINEAR_FEATURES', '数据特征非线性强、特征交互复杂', 'NONLINEAR_MODEL', 'HETERO_SECUREBOOST', 'SecureBoost 更适合处理非线性和复杂特征交互。', 50),
  (7, 'RULE_EXPLAINABILITY', '业务需要较强可解释性', 'EXPLAINABLE_MODEL', 'HETERO_LR', '逻辑回归参数可解释性更强，适合作为风控评分基线。', 40),
  (8, 'RULE_LOW_OVERLAP_TRANSFER', '样本重叠较少但存在知识迁移需求', 'TRANSFER_LEARNING', 'FEDERATED_TRANSFER_LEARNING', '可作为后续扩展方向，使用联邦迁移学习缓解样本重叠不足。', 30);
