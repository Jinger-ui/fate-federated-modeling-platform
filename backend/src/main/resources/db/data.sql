insert ignore into sys_role(id, role_code, role_name, status) values
  (1, 'ADMIN', '平台管理员', 1),
  (2, 'ORG_USER', '机构操作员', 1),
  (3, 'AUDITOR', '审计员', 1);

insert ignore into org_info(id, org_code, org_name, org_type, party_id, contact_person, contact_phone, status, remark) values
  (1, 'BANK001', '示例银行机构', 'BANK', '9999', '银行负责人', '13800000001', 1, '持有标签与金融特征'),
  (2, 'OPERATOR001', '示例运营商机构', 'OPERATOR', '10000', '运营商负责人', '13800000002', 1, '持有通信行为特征');

insert ignore into org_node_config(id, org_id, node_host, node_port, data_namespace, fate_version, config_json) values
  (1, 1, 'localhost', 9380, 'bank_credit_risk', 'standalone', json_object('role', 'guest')),
  (2, 2, 'localhost', 9380, 'operator_credit_risk', 'standalone', json_object('role', 'host'));

insert ignore into data_asset(id, asset_code, asset_name, org_id, asset_type, source_type, source_ref, id_field, label_field, sample_count, status, version_no, created_by) values
  (1, 'BANK_TRAIN_V1', '银行信用风险训练集V1', 1, 'TRAIN', 'FATE_TABLE', 'bank_credit_risk.bank_train_v1', 'user_id', 'is_overdue', 5000, 'VALID', 'v1', 1),
  (2, 'OPERATOR_TRAIN_V1', '运营商通信行为训练集V1', 2, 'TRAIN', 'FATE_TABLE', 'operator_credit_risk.operator_train_v1', 'user_id', null, 6200, 'VALID', 'v1', 1);

insert ignore into data_asset_field(asset_id, field_name, field_type, field_role, nullable_flag, description) values
  (1, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (1, 'age', 'int', 'FEATURE', 1, '年龄'),
  (1, 'credit_score', 'decimal', 'FEATURE', 1, '信用评分'),
  (1, 'loan_amount', 'decimal', 'FEATURE', 1, '贷款金额'),
  (1, 'is_overdue', 'int', 'LABEL', 0, '是否逾期'),
  (2, 'user_id', 'string', 'ID', 0, '用户唯一标识'),
  (2, 'net_age_months', 'int', 'FEATURE', 1, '在网时长'),
  (2, 'monthly_fee', 'decimal', 'FEATURE', 1, '月套餐消费'),
  (2, 'arrears_count', 'int', 'FEATURE', 1, '欠费次数');
