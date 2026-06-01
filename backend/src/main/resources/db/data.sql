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
  (2, 'HETERO_LR', 'Hetero Logistic Regression', 'VERTICAL_CLASSIFICATION', 'HeteroLR', 'VERTICAL', 'BINARY_CLASSIFICATION', 'HIGH', 0, 1, 'Accuracy,Precision,Recall,F1,AUC,KS,Loss', '信用风险预测；贷款违约预测；反欺诈识别；风控评分', 0, json_object('max_iter',30,'learning_rate',0.05,'batch_size',64), 20),
  (3, 'HETERO_SECUREBOOST', 'Hetero SecureBoost', 'VERTICAL_CLASSIFICATION', 'HeteroSecureBoost', 'VERTICAL', 'BINARY_CLASSIFICATION', 'MEDIUM', 1, 1, 'Accuracy,Precision,Recall,F1,AUC,KS,Loss', '信用风险预测；反欺诈识别；营销转化预测；复杂特征交互建模', 0, json_object('num_trees',50,'max_depth',4,'learning_rate',0.1), 30),
  (4, 'HOMO_LR', 'Homo Logistic Regression', 'HORIZONTAL_CLASSIFICATION', 'HomoLR', 'HORIZONTAL', 'BINARY_CLASSIFICATION', 'HIGH', 0, 0, 'Accuracy,Precision,Recall,F1,AUC,Loss', '多家银行拥有相同字段但不同客户样本', 1, json_object('max_iter',30,'learning_rate',0.05), 40),
  (5, 'HOMO_SECUREBOOST', 'Homo SecureBoost', 'HORIZONTAL_CLASSIFICATION', 'HomoSecureBoost', 'HORIZONTAL', 'BINARY_CLASSIFICATION', 'MEDIUM', 1, 0, 'Accuracy,Precision,Recall,F1,AUC,Loss', '同构特征的跨机构分类建模', 1, json_object('num_trees',50,'max_depth',4), 50),
  (6, 'HETERO_LINEAR_REGRESSION', 'Hetero Linear Regression', 'FEDERATED_REGRESSION', 'HeteroLinR', 'VERTICAL', 'REGRESSION', 'HIGH', 0, 1, 'MAE,MSE,RMSE,R2,Loss', '用户消费金额预测；信贷额度预测；评分预测', 1, json_object('max_iter',30,'learning_rate',0.05), 60),
  (7, 'SECUREBOOST_REGRESSION', 'SecureBoost Regression', 'FEDERATED_REGRESSION', 'HeteroSecureBoost', 'VERTICAL', 'REGRESSION', 'MEDIUM', 1, 1, 'MAE,MSE,RMSE,R2,Loss', '额度预测；收入预测；复杂非线性回归任务', 1, json_object('objective','regression','num_trees',50,'max_depth',4), 70),
  (8, 'POISSON_REGRESSION', 'Poisson Regression', 'FEDERATED_REGRESSION', 'PoissonRegression', 'VERTICAL', 'COUNT_REGRESSION', 'HIGH', 0, 1, 'MAE,MSE,Deviance,Loss', '次数预测；事件频次预测；理赔次数预测', 1, json_object('max_iter',30,'learning_rate',0.05), 80),
  (9, 'FEDERATED_NN', 'Federated Neural Network', 'FEDERATED_DEEP_LEARNING', 'HeteroNN/HomoNN', 'MIXED', 'DEEP_LEARNING', 'LOW', 1, 0, 'Accuracy,AUC,Loss', '复杂特征表达；图像文本多模态；深度模型扩展方向', 1, json_object('epochs',10,'batch_size',128), 90),
  (10, 'FEDERATED_TRANSFER_LEARNING', 'Federated Transfer Learning', 'TRANSFER_LEARNING', 'FTL', 'TRANSFER', 'TRANSFER_LEARNING', 'LOW', 1, 0, 'Accuracy,AUC,Loss', '样本重叠较少但存在知识迁移需求的场景', 1, json_object('epochs',10,'overlap_ratio','low'), 100);

insert ignore into business_scenario_template(id, scenario_code, scenario_name, participant_types, data_distribution, label_owner, recommended_federated_type, recommended_algorithms, recommended_metrics, need_psi, business_goal, sort_no) values
  (1, 'BANK_OPERATOR_CREDIT_RISK', '银行与运营商信用风险预测', '银行机构,运营商机构', 'VERTICAL', '银行机构', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST', 'Accuracy,Precision,Recall,F1,AUC,KS,Loss', 1, '在原始数据不出域前提下融合金融信用特征与通信行为特征，预测贷款逾期风险。', 10),
  (2, 'BANK_PAY_OPERATOR_FRAUD', '银行、支付平台与运营商反欺诈识别', '银行机构,支付平台,运营商机构', 'VERTICAL', '银行或支付平台', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_SECUREBOOST,HETERO_LR', 'Precision,Recall,F1,AUC,KS', 1, '融合交易、账户、通信行为特征识别欺诈交易或异常申请。', 20),
  (3, 'OPERATOR_INTERNET_CHURN', '运营商与互联网平台客户流失预测', '运营商机构,互联网平台', 'VERTICAL', '运营商机构', '纵向联邦学习', 'PSI_INTERSECTION,HETERO_LR,HETERO_SECUREBOOST', 'Accuracy,Recall,F1,AUC,Loss', 1, '通过通信行为和互联网活跃特征预测客户流失概率，支撑精细化运营。', 30),
  (4, 'MULTI_BANK_HOMO_RISK', '多银行同构信用风险联合建模', '商业银行,区域银行,消费金融机构', 'HORIZONTAL', '各参与银行', '横向联邦学习', 'HOMO_LR,HOMO_SECUREBOOST', 'Accuracy,Precision,Recall,F1,AUC,Loss', 0, '多家银行字段结构一致但样本不同，通过横向联邦提升模型泛化能力。', 40);

insert ignore into algorithm_recommend_rule(id, rule_code, condition_desc, recommended_type, recommended_algorithm, reason, priority) values
  (1, 'RULE_VERTICAL_FEATURE_SPLIT', '多方拥有相同用户但不同特征', 'VERTICAL', 'HETERO_LR,HETERO_SECUREBOOST', '该数据分布符合纵向联邦学习，需先进行 PSI 样本对齐。', 100),
  (2, 'RULE_HORIZONTAL_SAMPLE_SPLIT', '多方拥有相同字段但不同样本', 'HORIZONTAL', 'HOMO_LR,HOMO_SECUREBOOST', '字段结构一致且样本不同，适合横向联邦训练统一模型。', 90),
  (3, 'RULE_BINARY_TARGET', '任务目标为是否违约、是否欺诈、是否流失', 'CLASSIFICATION', 'HETERO_LR,HETERO_SECUREBOOST', '二分类风控任务可优先选择逻辑回归基线和 SecureBoost 效果模型。', 80),
  (4, 'RULE_CONTINUOUS_TARGET', '任务目标为金额、额度、评分等连续值', 'REGRESSION', 'HETERO_LINEAR_REGRESSION,SECUREBOOST_REGRESSION', '连续值预测适合联邦回归算法或树模型回归目标。', 70),
  (5, 'RULE_COUNT_TARGET', '任务目标为次数预测', 'COUNT_REGRESSION', 'POISSON_REGRESSION,SECUREBOOST_REGRESSION', '计数型目标可考虑 Poisson Regression 或回归类树模型。', 60),
  (6, 'RULE_NONLINEAR_FEATURES', '数据特征非线性强、特征交互复杂', 'NONLINEAR_MODEL', 'HETERO_SECUREBOOST', 'SecureBoost 更适合处理非线性和复杂特征交互。', 50),
  (7, 'RULE_EXPLAINABILITY', '业务需要较强可解释性', 'EXPLAINABLE_MODEL', 'HETERO_LR', '逻辑回归参数可解释性更强，适合作为风控评分基线。', 40),
  (8, 'RULE_LOW_OVERLAP_TRANSFER', '样本重叠较少但存在知识迁移需求', 'TRANSFER_LEARNING', 'FEDERATED_TRANSFER_LEARNING', '可作为后续扩展方向，使用联邦迁移学习缓解样本重叠不足。', 30);
