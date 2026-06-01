# 数据库详细设计与 API 接口文档

题目：基于 FATE 的多方数据安全联合建模平台设计与实现

## 1. 文档说明

本文档用于支撑项目实现阶段，重点说明数据库详细设计、表之间关系、核心字段含义、典型 SQL 建表建议以及 REST API 接口定义。其定位偏“开发设计说明书”，适合用于系统实现、论文附录、课程设计说明书和简历项目展示。

## 2. 数据库设计原则

1. 平台数据库只存储系统管理数据、任务配置、运行结果和审计日志。
2. 不存储银行与运营商的原始业务明文样本数据。
3. 对联邦任务参数、曲线数据、外部响应报文等内容采用 JSON 扩展字段设计。
4. 通过机构字段实现多租户隔离，通过审计字段实现可追踪。
5. 表结构设计兼顾演示场景和后续可扩展性。

## 3. 数据库逻辑分层

数据库主要分为六个业务域：

1. 用户权限域
2. 机构节点域
3. 数据资产域
4. PSI 样本对齐域
5. 联邦训练任务域
6. 模型报告与审计域

## 4. 核心表详细设计

### 4.1 用户与权限相关表

#### 4.1.1 `sys_user`

**作用**

存储平台用户信息。

**核心字段**

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| username | varchar(64) | 登录账号，唯一 |
| password | varchar(255) | BCrypt 加密密码 |
| real_name | varchar(64) | 用户姓名 |
| org_id | bigint | 所属机构 ID |
| phone | varchar(32) | 联系电话 |
| email | varchar(128) | 邮箱 |
| status | tinyint | 1启用 0禁用 |
| created_at | datetime | 创建时间 |
| updated_at | datetime | 更新时间 |

**建表建议**

```sql
create table sys_user (
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
```

#### 4.1.2 `sys_role`

**作用**

存储角色定义，例如管理员、机构操作员、审计员。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| role_code | varchar(64) | 角色编码 |
| role_name | varchar(64) | 角色名称 |
| status | tinyint | 状态 |
| remark | varchar(255) | 备注 |

#### 4.1.3 `sys_permission`

**作用**

存储菜单权限或接口权限。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| perm_code | varchar(100) | 权限编码 |
| perm_name | varchar(100) | 权限名称 |
| perm_type | varchar(32) | MENU 或 API |
| path | varchar(255) | 路由或接口路径 |
| method | varchar(16) | HTTP 方法 |

#### 4.1.4 `sys_user_role`

**作用**

维护用户与角色的多对多关系。

#### 4.1.5 `sys_role_permission`

**作用**

维护角色与权限的多对多关系。

### 4.2 机构与节点相关表

#### 4.2.1 `org_info`

**作用**

存储参与联邦建模的机构主体。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| org_code | varchar(64) | 机构编码 |
| org_name | varchar(100) | 机构名称 |
| org_type | varchar(32) | BANK、OPERATOR、ADMIN |
| party_id | varchar(32) | FATE 参与方标识 |
| contact_person | varchar(64) | 联系人 |
| contact_phone | varchar(32) | 联系电话 |
| status | tinyint | 状态 |
| remark | varchar(255) | 备注 |

**建表建议**

```sql
create table org_info (
  id bigint primary key auto_increment,
  org_code varchar(64) not null,
  org_name varchar(100) not null,
  org_type varchar(32) not null,
  party_id varchar(32) not null,
  contact_person varchar(64),
  contact_phone varchar(32),
  status tinyint not null default 1,
  remark varchar(255),
  unique key uk_org_info_org_code (org_code),
  unique key uk_org_info_party_id (party_id)
);
```

#### 4.2.2 `org_node_config`

**作用**

存储机构与底层 FATE 节点的映射配置。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| org_id | bigint | 机构ID |
| node_host | varchar(128) | 节点地址 |
| node_port | int | 节点端口 |
| data_namespace | varchar(128) | FATE 数据命名空间 |
| fate_version | varchar(64) | FATE 版本 |
| config_json | json | 扩展配置 |

### 4.3 数据资产相关表

#### 4.3.1 `data_asset`

**作用**

管理数据集元信息，而不是原始样本内容。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| asset_code | varchar(64) | 数据集编码 |
| asset_name | varchar(128) | 数据集名称 |
| org_id | bigint | 所属机构 |
| asset_type | varchar(32) | TRAIN、TEST、PREDICT |
| source_type | varchar(32) | CSV、MYSQL_TABLE、FATE_TABLE |
| source_ref | varchar(255) | 文件路径、表名或命名空间引用 |
| id_field | varchar(64) | 样本主键字段 |
| label_field | varchar(64) | 标签字段 |
| sample_count | int | 样本量 |
| status | varchar(32) | INIT、VALID、INVALID |
| version_no | varchar(32) | 版本号 |
| created_by | bigint | 创建人 |
| created_at | datetime | 创建时间 |

**建表建议**

```sql
create table data_asset (
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
  key idx_data_asset_org_id (org_id),
  key idx_data_asset_status (status)
);
```

#### 4.3.2 `data_asset_field`

**作用**

记录数据资产字段定义。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| asset_id | bigint | 数据资产ID |
| field_name | varchar(64) | 字段名 |
| field_type | varchar(32) | 字段类型 |
| field_role | varchar(32) | ID、LABEL、FEATURE、IGNORE |
| nullable_flag | tinyint | 是否可空 |
| description | varchar(255) | 字段说明 |

#### 4.3.3 `data_asset_version`

**作用**

记录数据资产版本演进信息。

### 4.4 PSI 样本对齐相关表

#### 4.4.1 `psi_task`

**作用**

记录样本对齐任务主信息。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_code | varchar(64) | 对齐任务编码 |
| task_name | varchar(128) | 对齐任务名称 |
| guest_org_id | bigint | 发起方机构ID |
| host_org_id | bigint | 协作方机构ID |
| status | varchar(32) | WAITING、RUNNING、SUCCESS、FAILED |
| id_field | varchar(64) | 样本主键字段 |
| submit_time | datetime | 提交时间 |
| finish_time | datetime | 完成时间 |
| result_ref | varchar(255) | 结果引用位置 |
| intersect_count | int | 交集样本量 |
| error_msg | varchar(1000) | 错误信息 |

#### 4.4.2 `psi_task_party`

**作用**

记录 PSI 任务的参与方及其角色。

#### 4.4.3 `psi_task_result`

**作用**

记录 PSI 结果摘要。建议只存摘要和引用，不存明文交集 ID。

### 4.5 联邦训练任务相关表

#### 4.5.1 `federated_task`

**作用**

记录联邦建模任务主信息。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_code | varchar(64) | 任务编码 |
| task_name | varchar(128) | 任务名称 |
| task_mode | varchar(32) | SINGLE_BANK、SINGLE_OPERATOR、FEDERATED |
| algorithm_type | varchar(64) | HETERO_LR、HETERO_SECUREBOOST |
| psi_task_id | bigint | 关联PSI任务ID |
| status | varchar(32) | DRAFT、WAITING、RUNNING、SUCCESS、FAILED、CANCELED |
| submit_type | varchar(32) | MOCK、PIPELINE、FLOW_API |
| external_job_id | varchar(128) | FATE外部任务ID |
| created_by | bigint | 创建人 |
| created_at | datetime | 创建时间 |
| submit_time | datetime | 提交时间 |
| finish_time | datetime | 完成时间 |
| error_msg | varchar(1000) | 错误信息 |

**建表建议**

```sql
create table federated_task (
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
  key idx_federated_task_status (status),
  key idx_federated_task_created_at (created_at)
);
```

#### 4.5.2 `federated_task_party`

**作用**

记录联邦任务的参与方配置。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_id | bigint | 联邦任务ID |
| org_id | bigint | 机构ID |
| role_type | varchar(32) | GUEST、HOST、ARBITER |
| asset_id | bigint | 数据资产ID |
| party_id | varchar(32) | FATE partyId |
| has_label | tinyint | 是否持有标签 |

#### 4.5.3 `federated_task_param`

**作用**

存储任务参数，支持算法参数、训练参数和运行参数分组。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_id | bigint | 联邦任务ID |
| param_type | varchar(32) | ALGO、DATASET、RUNTIME |
| param_json | json | 参数JSON |

#### 4.5.4 `federated_task_result`

**作用**

记录联邦任务结果摘要。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_id | bigint | 联邦任务ID |
| model_name | varchar(128) | 模型名称 |
| model_version | varchar(64) | 模型版本 |
| metric_summary_json | json | 指标摘要 |
| artifact_ref | varchar(255) | 模型或结果文件引用 |
| report_status | varchar(32) | INIT、GENERATED |

#### 4.5.5 `fate_job_mapping`

**作用**

维护平台任务与 FATE 外部任务之间的映射关系。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_id | bigint | 联邦任务ID |
| external_job_id | varchar(128) | FATE jobId |
| job_type | varchar(32) | PSI、TRAIN |
| submit_payload | json | 提交报文 |
| response_payload | json | 返回报文 |
| last_sync_time | datetime | 最近同步时间 |

#### 4.5.6 `task_runtime_snapshot`

**作用**

记录联邦任务运行时快照。

#### 4.5.7 `task_runtime_log`

**作用**

记录运行日志明细。

### 4.6 模型评估相关表

#### 4.6.1 `model_report`

**作用**

记录某一任务的模型报告主表数据。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| task_id | bigint | 联邦任务ID |
| report_name | varchar(128) | 报告名称 |
| dataset_type | varchar(32) | TRAIN、VALID、TEST |
| accuracy | decimal(10,4) | 准确率 |
| precision_rate | decimal(10,4) | 精确率 |
| recall_rate | decimal(10,4) | 召回率 |
| f1_score | decimal(10,4) | F1值 |
| auc | decimal(10,4) | AUC |
| ks | decimal(10,4) | KS |
| loss | decimal(10,4) | Loss |
| summary_text | text | 结果说明 |

#### 4.6.2 `model_metric`

**作用**

用于扩展保存标准指标和自定义指标。

#### 4.6.3 `model_curve_data`

**作用**

保存 ROC 曲线、PR 曲线、Loss 曲线等点位数据。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| report_id | bigint | 报告ID |
| curve_type | varchar(32) | ROC、LOSS、KS |
| curve_json | json | 曲线点位数据 |

### 4.7 审计日志相关表

#### 4.7.1 `audit_log`

**作用**

记录所有关键业务操作。

| 字段名 | 类型 | 说明 |
|---|---|---|
| id | bigint | 主键 |
| user_id | bigint | 用户ID |
| username | varchar(64) | 用户名 |
| org_id | bigint | 所属机构 |
| module_name | varchar(64) | 模块名称 |
| operation_type | varchar(64) | 操作类型 |
| request_uri | varchar(255) | 请求路径 |
| request_method | varchar(16) | 请求方法 |
| request_param | text | 请求参数摘要 |
| response_code | varchar(16) | 响应码 |
| success_flag | tinyint | 是否成功 |
| cost_ms | bigint | 耗时 |
| ip | varchar(64) | 来源IP |
| created_at | datetime | 创建时间 |

#### 4.7.2 `login_log`

**作用**

记录登录成功或失败信息。

## 5. 关键表关系说明

1. 一个机构可以拥有多个用户和多个数据资产。
2. 一个数据资产属于一个机构，但可以参与多个 PSI 或联邦建模任务。
3. 一个 PSI 任务包含两个或多个参与方记录。
4. 一个联邦任务可以关联一个 PSI 任务，也可以用于单方实验。
5. 一个联邦任务可以对应多条运行快照和多条运行日志。
6. 一个联邦任务最终可以生成一份或多份模型评估报告。

## 6. 索引与性能设计建议

1. `sys_user.username`、`org_info.org_code`、`org_info.party_id`、`data_asset.asset_code`、`federated_task.task_code` 建唯一索引。
2. 任务相关表对 `status`、`created_at`、`task_id` 建普通索引。
3. 审计日志表对 `module_name`、`created_at` 和 `user_id` 建组合索引。
4. 曲线和大日志内容建议采用延迟加载，列表页只查摘要。
5. 如日志量较大，可按月分表或迁移到独立日志库。

## 7. REST API 总体规范

### 7.1 基础规范

1. 基础路径统一为 `/api`。
2. 请求体采用 `application/json`。
3. 认证方式采用 `Authorization: Bearer <token>`。
4. 响应结构统一如下：

```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

5. 分页参数统一使用 `pageNum` 和 `pageSize`。
6. 时间字段统一采用 `yyyy-MM-dd HH:mm:ss`。

### 7.2 状态码建议

| code | 说明 |
|---|---|
| 200 | 成功 |
| 400 | 参数错误 |
| 401 | 未认证 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 500 | 系统异常 |

## 8. API 详细设计

### 8.1 认证与用户模块

#### 8.1.1 登录

**接口**

`POST /api/auth/login`

**请求参数**

```json
{
  "username": "admin",
  "password": "123456"
}
```

**返回示例**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9.demo",
    "userInfo": {
      "id": 1,
      "username": "admin",
      "realName": "系统管理员",
      "orgId": 1
    }
  }
}
```

#### 8.1.2 获取当前用户信息

`GET /api/auth/me`

#### 8.1.3 获取当前用户菜单

`GET /api/auth/menus`

#### 8.1.4 用户列表

`GET /api/users?pageNum=1&pageSize=10`

#### 8.1.5 新增用户

`POST /api/users`

### 8.2 机构管理模块

#### 8.2.1 查询机构列表

`GET /api/orgs`

**响应字段**

`id`、`orgCode`、`orgName`、`orgType`、`partyId`、`status`

#### 8.2.2 新增机构

`POST /api/orgs`

**请求示例**

```json
{
  "orgCode": "BANK001",
  "orgName": "某银行总行",
  "orgType": "BANK",
  "partyId": "9999",
  "contactPerson": "张老师",
  "contactPhone": "13800000000"
}
```

#### 8.2.3 更新机构

`PUT /api/orgs/{id}`

### 8.3 数据资产管理模块

#### 8.3.1 查询数据资产列表

`GET /api/data-assets?pageNum=1&pageSize=10&orgId=1`

#### 8.3.2 新增数据资产

`POST /api/data-assets`

**请求示例**

```json
{
  "assetCode": "BANK_TRAIN_V1",
  "assetName": "银行训练集V1",
  "orgId": 1,
  "assetType": "TRAIN",
  "sourceType": "CSV",
  "sourceRef": "/data/bank_train_v1.csv",
  "idField": "user_id",
  "labelField": "is_overdue",
  "sampleCount": 5000,
  "versionNo": "v1"
}
```

#### 8.3.3 查询字段列表

`GET /api/data-assets/{id}/fields`

#### 8.3.4 校验数据资产

`POST /api/data-assets/{id}/validate`

**逻辑说明**

校验主键是否存在、标签字段是否合法、样本量是否大于0、字段角色是否完整。

### 8.4 PSI 样本对齐模块

#### 8.4.1 创建样本对齐任务

`POST /api/psi/tasks`

**请求示例**

```json
{
  "taskName": "银行运营商样本对齐任务1",
  "guestOrgId": 1,
  "hostOrgId": 2,
  "guestAssetId": 11,
  "hostAssetId": 21,
  "idField": "user_id",
  "runMode": "MOCK"
}
```

**返回示例**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "taskId": 101,
    "taskCode": "PSI202606010001",
    "status": "WAITING"
  }
}
```

#### 8.4.2 查询 PSI 任务列表

`GET /api/psi/tasks`

#### 8.4.3 查询 PSI 任务详情

`GET /api/psi/tasks/{id}`

#### 8.4.4 查询 PSI 结果

`GET /api/psi/tasks/{id}/result`

**响应重点**

返回交集样本量、运行时间、结果引用地址、执行状态，不返回明文交集 ID。

### 8.5 联邦建模任务模块

#### 8.5.1 创建联邦任务

`POST /api/federated/tasks`

**请求示例**

```json
{
  "taskName": "银行运营商联合建模LR实验",
  "taskMode": "FEDERATED",
  "algorithmType": "HETERO_LR",
  "psiTaskId": 101,
  "submitType": "PIPELINE",
  "parties": [
    {
      "orgId": 1,
      "roleType": "GUEST",
      "assetId": 11,
      "partyId": "9999",
      "hasLabel": 1
    },
    {
      "orgId": 2,
      "roleType": "HOST",
      "assetId": 21,
      "partyId": "10000",
      "hasLabel": 0
    }
  ],
  "algoParams": {
    "maxIter": 30,
    "learningRate": 0.05,
    "batchSize": 64
  }
}
```

#### 8.5.2 查询联邦任务列表

`GET /api/federated/tasks`

#### 8.5.3 查询联邦任务详情

`GET /api/federated/tasks/{id}`

#### 8.5.4 提交联邦任务

`POST /api/federated/tasks/{id}/submit`

**说明**

提交后平台返回平台任务号和外部任务号，实际执行采用异步处理。

#### 8.5.5 重试任务

`POST /api/federated/tasks/{id}/retry`

#### 8.5.6 查询任务运行状态

`GET /api/federated/tasks/{id}/runtime`

**响应字段建议**

`status`、`externalJobId`、`progressStage`、`startTime`、`finishTime`、`costMs`、`lastMessage`

#### 8.5.7 查询任务日志

`GET /api/federated/tasks/{id}/logs`

### 8.6 FATE 调用管理模块

#### 8.6.1 手动触发任务提交

`POST /api/fate/jobs/submit`

#### 8.6.2 查询外部任务状态

`GET /api/fate/jobs/{taskId}/status`

#### 8.6.3 查询外部任务日志

`GET /api/fate/jobs/{taskId}/logs`

**实现说明**

该模块一般由后端内部服务调用，但为了答辩演示或调试方便，可以保留管理接口。

### 8.7 模型评估报告模块

#### 8.7.1 查询任务评估摘要

`GET /api/reports/{taskId}/summary`

**响应示例**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "taskId": 201,
    "taskName": "银行运营商联合建模LR实验",
    "algorithmType": "HETERO_LR",
    "accuracy": 0.8652,
    "precision": 0.8214,
    "recall": 0.7932,
    "f1Score": 0.8071,
    "auc": 0.9026,
    "ks": 0.5341,
    "loss": 0.3245
  }
}
```

#### 8.7.2 查询指标明细

`GET /api/reports/{taskId}/metrics`

#### 8.7.3 查询曲线数据

`GET /api/reports/{taskId}/curves`

#### 8.7.4 查询多任务对比

`GET /api/reports/compare?taskIds=201,202,203`

### 8.8 审计日志模块

#### 8.8.1 查询审计日志

`GET /api/audit/logs?pageNum=1&pageSize=20&moduleName=TASK`

#### 8.8.2 查询登录日志

`GET /api/audit/login-logs`

### 8.9 首页看板模块

#### 8.9.1 查询概览数据

`GET /api/dashboard/overview`

**响应字段建议**

`orgCount`、`assetCount`、`taskCount`、`runningTaskCount`、`successRate`

#### 8.9.2 查询任务趋势

`GET /api/dashboard/task-trend`

#### 8.9.3 查询模型对比

`GET /api/dashboard/model-compare`

#### 8.9.4 查询最近活动

`GET /api/dashboard/recent-activities`

## 9. 后端分层实现建议

### 9.1 Controller 层

职责是接收请求、做基础参数校验、返回统一响应，不直接写业务逻辑。

### 9.2 Service 层

职责是封装业务规则、事务控制和多表协同，是系统核心逻辑层。

### 9.3 Adapter 层

职责是对接 FATE Pipeline、FATE Flow API、本地脚本执行器等外部能力。

### 9.4 Mapper 层

职责是数据库持久化操作，建议按领域划分 Mapper 与 XML。

### 9.5 DTO / VO 设计建议

1. DTO 用于请求参数承载。
2. VO 用于响应视图模型。
3. Entity 用于持久化对象。
4. Convert 层建议使用 MapStruct 或手写转换。

## 10. 安全与审计落地建议

1. 登录接口记录成功和失败日志。
2. 所有新增、编辑、删除、提交操作记录审计日志。
3. 接口按角色和机构做数据权限限制。
4. 对密码、电话号码、路径等敏感信息做脱敏或摘要存储。
5. FATE 调用报文中如含敏感配置，应只保留必要摘要。

## 11. 本文档使用建议

1. 若用于论文，可将第4章内容拆分到“数据库设计”和“接口设计”小节。
2. 若用于课程设计，可直接附上核心建表 SQL 和接口截图。
3. 若用于项目实现，可据此继续生成实体类、Mapper、Controller 和 Swagger 注解。
