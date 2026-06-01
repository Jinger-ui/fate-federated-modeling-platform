create table if not exists sys_role (
  id bigint primary key auto_increment,
  role_code varchar(64) not null,
  role_name varchar(64) not null,
  status tinyint not null default 1,
  unique key uk_sys_role_code (role_code)
);

create table if not exists sys_user (
  id bigint primary key auto_increment,
  username varchar(64) not null,
  password varchar(255) not null,
  real_name varchar(64),
  org_id bigint,
  phone varchar(32),
  email varchar(128),
  status tinyint not null default 1,
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  unique key uk_sys_user_username (username),
  key idx_sys_user_org_id (org_id)
);

create table if not exists sys_user_role (
  id bigint primary key auto_increment,
  user_id bigint not null,
  role_id bigint not null,
  unique key uk_user_role (user_id, role_id)
);

create table if not exists sys_permission (
  id bigint primary key auto_increment,
  perm_code varchar(100) not null,
  perm_name varchar(100) not null,
  perm_type varchar(32) not null,
  path varchar(255),
  method varchar(16),
  unique key uk_permission_code (perm_code)
);

create table if not exists sys_role_permission (
  id bigint primary key auto_increment,
  role_id bigint not null,
  permission_id bigint not null,
  unique key uk_role_permission (role_id, permission_id)
);

create table if not exists org_info (
  id bigint primary key auto_increment,
  org_code varchar(64) not null,
  org_name varchar(100) not null,
  org_type varchar(32) not null,
  party_id varchar(32) not null,
  contact_person varchar(64),
  contact_phone varchar(32),
  status tinyint not null default 1,
  remark varchar(255),
  unique key uk_org_code (org_code),
  unique key uk_party_id (party_id)
);

create table if not exists org_node_config (
  id bigint primary key auto_increment,
  org_id bigint not null,
  node_host varchar(128),
  node_port int,
  data_namespace varchar(128),
  fate_version varchar(64),
  config_json json
);

create table if not exists data_asset (
  id bigint primary key auto_increment,
  asset_code varchar(64) not null,
  asset_name varchar(128) not null,
  org_id bigint not null,
  asset_type varchar(32) not null,
  source_type varchar(32) not null,
  source_ref varchar(255) not null,
  id_field varchar(64) not null,
  label_field varchar(64),
  sample_count int default 0,
  status varchar(32) not null default 'INIT',
  version_no varchar(32) default 'v1',
  created_by bigint,
  created_at datetime not null default current_timestamp,
  unique key uk_data_asset_code (asset_code),
  key idx_data_asset_org (org_id),
  key idx_data_asset_status (status)
);

create table if not exists data_asset_field (
  id bigint primary key auto_increment,
  asset_id bigint not null,
  field_name varchar(64) not null,
  field_type varchar(32) not null,
  field_role varchar(32) not null,
  nullable_flag tinyint not null default 1,
  description varchar(255),
  unique key uk_asset_field (asset_id, field_name),
  key idx_asset_field_asset (asset_id)
);

create table if not exists psi_task (
  id bigint primary key auto_increment,
  task_code varchar(64) not null,
  task_name varchar(128) not null,
  guest_org_id bigint not null,
  host_org_id bigint not null,
  guest_asset_id bigint not null,
  host_asset_id bigint not null,
  status varchar(32) not null default 'WAITING',
  run_mode varchar(32) not null default 'MOCK',
  id_field varchar(64) not null,
  submit_time datetime,
  finish_time datetime,
  result_ref varchar(255),
  intersect_count int,
  error_msg varchar(1000),
  created_at datetime not null default current_timestamp,
  unique key uk_psi_task_code (task_code),
  key idx_psi_status (status)
);

create table if not exists federated_task (
  id bigint primary key auto_increment,
  task_code varchar(64) not null,
  task_name varchar(128) not null,
  task_mode varchar(32) not null,
  algorithm_type varchar(64) not null,
  psi_task_id bigint,
  status varchar(32) not null default 'DRAFT',
  submit_type varchar(32) not null default 'MOCK',
  external_job_id varchar(128),
  created_by bigint,
  created_at datetime not null default current_timestamp,
  submit_time datetime,
  finish_time datetime,
  error_msg varchar(1000),
  unique key uk_federated_task_code (task_code),
  key idx_federated_status (status),
  key idx_federated_created_at (created_at)
);

create table if not exists federated_task_party (
  id bigint primary key auto_increment,
  task_id bigint not null,
  org_id bigint not null,
  role_type varchar(32) not null,
  asset_id bigint not null,
  party_id varchar(32) not null,
  has_label tinyint not null default 0,
  key idx_task_party_task (task_id)
);

create table if not exists federated_task_param (
  id bigint primary key auto_increment,
  task_id bigint not null,
  param_type varchar(32) not null,
  param_json json,
  key idx_task_param_task (task_id)
);

create table if not exists fate_job_mapping (
  id bigint primary key auto_increment,
  task_id bigint not null,
  external_job_id varchar(128) not null,
  job_type varchar(32) not null,
  submit_payload json,
  response_payload json,
  last_sync_time datetime,
  unique key uk_fate_external_job (external_job_id)
);

create table if not exists fate_engine_component (
  id bigint primary key auto_increment,
  component_code varchar(64) not null,
  component_name varchar(128) not null,
  layer_type varchar(64) not null,
  capability varchar(500) not null,
  implementation_ref varchar(255),
  enabled_flag tinyint not null default 1,
  sort_no int not null default 0,
  unique key uk_engine_component_code (component_code)
);

create table if not exists federated_algorithm_template (
  id bigint primary key auto_increment,
  algorithm_code varchar(64) not null,
  algorithm_name varchar(128) not null,
  algorithm_category varchar(64) not null,
  fate_component varchar(128),
  federated_type varchar(64) not null,
  task_target varchar(64) not null,
  explainability_level varchar(32) not null,
  nonlinear_support tinyint not null default 0,
  need_psi tinyint not null default 1,
  metrics varchar(255),
  applicable_scenarios varchar(500),
  extension_flag tinyint not null default 0,
  default_params json,
  enabled_flag tinyint not null default 1,
  sort_no int not null default 0,
  unique key uk_algorithm_template_code (algorithm_code),
  key idx_algorithm_category (algorithm_category)
);

create table if not exists algorithm_experiment_layer (
  id bigint primary key auto_increment,
  layer_code varchar(64) not null,
  layer_name varchar(128) not null,
  layer_level int not null,
  model_family varchar(128) not null,
  algorithms varchar(255) not null,
  experiment_role varchar(255) not null,
  implementation_scope varchar(64) not null,
  comparison_value varchar(500) not null,
  enabled_flag tinyint not null default 1,
  unique key uk_algorithm_layer_code (layer_code)
);

create table if not exists feature_engineering_step (
  id bigint primary key auto_increment,
  step_code varchar(64) not null,
  step_name varchar(128) not null,
  step_order int not null,
  stage_type varchar(64) not null,
  target_fields varchar(255),
  method_desc varchar(500) not null,
  fate_component_ref varchar(128),
  implementation_scope varchar(64) not null,
  enabled_flag tinyint not null default 1,
  unique key uk_feature_step_code (step_code)
);

create table if not exists risk_threshold_strategy (
  id bigint primary key auto_increment,
  strategy_code varchar(64) not null,
  strategy_name varchar(128) not null,
  min_probability decimal(10,4) not null,
  max_probability decimal(10,4) not null,
  risk_level varchar(32) not null,
  risk_score_range varchar(64) not null,
  business_action varchar(255) not null,
  review_policy varchar(255),
  enabled_flag tinyint not null default 1,
  unique key uk_threshold_strategy_code (strategy_code)
);

create table if not exists experiment_design_template (
  id bigint primary key auto_increment,
  experiment_code varchar(32) not null,
  experiment_name varchar(128) not null,
  data_scope varchar(255) not null,
  algorithm_plan varchar(255) not null,
  experiment_purpose varchar(500) not null,
  baseline_flag tinyint not null default 0,
  core_flag tinyint not null default 1,
  sort_no int not null default 0,
  enabled_flag tinyint not null default 1,
  unique key uk_experiment_design_code (experiment_code)
);

create table if not exists feature_group (
  id bigint primary key auto_increment,
  dataset_id bigint,
  group_code varchar(64) not null,
  group_name varchar(128) not null,
  feature_columns varchar(500) not null,
  business_meaning varchar(500) not null,
  ablation_group varchar(32),
  ablation_purpose varchar(500),
  sort_no int not null default 0,
  enabled_flag tinyint not null default 1,
  unique key uk_feature_group_code (group_code)
);

create table if not exists algorithm_template (
  id bigint primary key auto_increment,
  algorithm_code varchar(64) not null,
  algorithm_name varchar(128) not null,
  federated_type varchar(64) not null,
  task_type varchar(64) not null,
  need_psi tinyint not null default 1,
  need_label_owner tinyint not null default 1,
  support_multi_host tinyint not null default 0,
  default_params json,
  default_metrics varchar(255),
  status varchar(32) not null default 'ENABLED',
  unique key uk_algorithm_template_code (algorithm_code)
);

create table if not exists scenario_template (
  id bigint primary key auto_increment,
  scenario_code varchar(64) not null,
  scenario_name varchar(128) not null,
  industry varchar(64) not null,
  task_type varchar(64) not null,
  label_definition varchar(255) not null,
  recommended_algorithm varchar(255) not null,
  recommended_metrics varchar(255) not null,
  description varchar(500) not null,
  status varchar(32) not null default 'ENABLED',
  unique key uk_scenario_template_code_v2 (scenario_code)
);

create table if not exists scenario_data_param (
  id bigint primary key auto_increment,
  scenario_code varchar(64) not null,
  party_type varchar(64) not null,
  party_role varchar(64) not null,
  label_owner tinyint not null default 0,
  label_definition varchar(255),
  data_fields varchar(1000) not null,
  feature_groups varchar(500),
  data_description varchar(500) not null,
  sample_relation varchar(255),
  privacy_note varchar(500),
  sort_no int not null default 0,
  enabled_flag tinyint not null default 1,
  key idx_scenario_data_param_code (scenario_code)
);

create table if not exists business_scenario_template (
  id bigint primary key auto_increment,
  scenario_code varchar(64) not null,
  scenario_name varchar(128) not null,
  participant_types varchar(255) not null,
  data_distribution varchar(64) not null,
  label_owner varchar(128) not null,
  recommended_federated_type varchar(64) not null,
  recommended_algorithms varchar(255) not null,
  recommended_metrics varchar(255) not null,
  need_psi tinyint not null default 1,
  business_goal varchar(500) not null,
  enabled_flag tinyint not null default 1,
  sort_no int not null default 0,
  unique key uk_scenario_template_code (scenario_code)
);

create table if not exists algorithm_recommend_rule (
  id bigint primary key auto_increment,
  rule_code varchar(64) not null,
  condition_desc varchar(500) not null,
  recommended_type varchar(64) not null,
  recommended_algorithm varchar(128) not null,
  reason varchar(500) not null,
  priority int not null default 0,
  enabled_flag tinyint not null default 1,
  unique key uk_algorithm_rule_code (rule_code)
);

create table if not exists task_runtime_log (
  id bigint primary key auto_increment,
  task_id bigint not null,
  log_level varchar(16) not null,
  log_time datetime not null default current_timestamp,
  content varchar(2000) not null,
  key idx_runtime_log_task (task_id)
);

create table if not exists model_report (
  id bigint primary key auto_increment,
  task_id bigint not null,
  report_name varchar(128) not null,
  dataset_type varchar(32) not null default 'TEST',
  accuracy decimal(10,4),
  precision_rate decimal(10,4),
  recall_rate decimal(10,4),
  f1_score decimal(10,4),
  auc decimal(10,4),
  ks decimal(10,4),
  loss decimal(10,4),
  summary_text text,
  created_at datetime not null default current_timestamp,
  key idx_model_report_task (task_id)
);

create table if not exists model_curve_data (
  id bigint primary key auto_increment,
  report_id bigint not null,
  curve_type varchar(32) not null,
  curve_json json,
  key idx_curve_report (report_id)
);

create table if not exists audit_log (
  id bigint primary key auto_increment,
  user_id bigint,
  username varchar(64),
  org_id bigint,
  module_name varchar(64),
  operation_type varchar(64),
  request_uri varchar(255),
  request_method varchar(16),
  request_param text,
  response_code varchar(16),
  success_flag tinyint,
  cost_ms bigint,
  ip varchar(64),
  created_at datetime not null default current_timestamp,
  key idx_audit_user (user_id),
  key idx_audit_module_time (module_name, created_at)
);

create table if not exists login_log (
  id bigint primary key auto_increment,
  username varchar(64),
  success_flag tinyint,
  failure_reason varchar(255),
  ip varchar(64),
  user_agent varchar(255),
  created_at datetime not null default current_timestamp
);
