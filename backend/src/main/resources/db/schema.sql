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
