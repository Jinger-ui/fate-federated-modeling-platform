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
