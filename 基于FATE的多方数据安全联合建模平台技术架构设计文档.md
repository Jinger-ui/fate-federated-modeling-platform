# 《基于 FATE 的多方数据安全联合建模平台设计与实现》技术架构设计文档

副标题：以银行与运营商信用风险预测为例

## 1. 项目概述

本项目旨在设计并实现一个面向多机构场景的数据安全联合建模平台，基于 FATE 联邦学习框架完成纵向联邦建模闭环。平台以“银行 + 运营商”信用风险预测为业务案例，在保证原始数据不出本地、不直接交换明文数据的前提下，实现样本对齐、任务编排、模型训练、训练监控、指标评估、审计留痕和可视化展示。

系统定位不是单一算法 Demo，而是一个具备平台化能力的联邦计算应用系统。平台通过前后端分离架构，对接 FATE Flow、FATE Pipeline 和 PSI 相关能力，将联邦训练流程沉淀为标准化任务，支持用户、机构、数据资产、模型任务和审计日志统一管理，适合用于毕业设计、课程设计和简历项目展示。

## 2. 业务背景

在传统信用风控场景中，银行掌握用户征信、贷款、还款、逾期标签等金融数据，运营商掌握通信行为、套餐消费、在网时长、欠费次数等补充行为数据。单一机构拥有的数据维度有限，导致模型对用户画像刻画不完整，风险识别能力受限。

但在真实业务中，原始数据受以下因素限制，无法直接共享：

1. 数据安全与隐私保护要求高，涉及用户敏感信息与业务核心数据。
2. 法规合规要求严格，跨机构明文共享存在较高法律与合规风险。
3. 商业竞争关系导致各机构不愿开放底层数据资产。
4. 数据口径、标识体系和系统架构不同，直接整合成本高。

因此，需要建设一个基于联邦学习与隐私计算的联合建模平台，使多方在“数据可用不可见”的前提下完成特征协同建模，提升风险预测效果。

## 3. 系统建设目标

### 3.1 业务目标

1. 在银行与运营商之间完成纵向联邦信用风险预测。
2. 提升风险识别效果，对比单方建模与联合建模的性能差异。
3. 形成标准化、可复用的联合建模流程，为后续扩展到医疗、政务、电商等领域提供参考。

### 3.2 技术目标

1. 建设统一 Web 平台，屏蔽底层 FATE 调用复杂性。
2. 实现任务化、配置化、可监控的联邦训练流程。
3. 建立完整的数据资产、模型任务、训练结果与审计日志管理能力。
4. 保障原始数据不出域，仅传递 ID 对齐信息、加密中间结果或指标结果。
5. 支持从模拟流程到真实 FATE Standalone 的分阶段落地。

### 3.3 工程目标

1. 采用前后端分离与模块化后端设计，便于开发、演示和扩展。
2. 使用 Docker Compose 统一部署应用、MySQL 和 FATE 运行环境。
3. 通过标准 REST API 提供前端交互与后续系统集成能力。
4. 输出可用于论文、答辩和简历展示的完整工程文档。

## 4. 技术选型

### 4.1 前端技术栈

1. `Vue 3`：采用组合式 API，便于构建模块化页面与状态管理。
2. `Vite`：提升前端开发与打包效率。
3. `Element Plus`：快速构建企业管理后台界面。
4. `Vue Router`：实现菜单、页面与权限路由控制。
5. `Pinia`：统一管理登录态、菜单权限、首页看板状态。
6. `Axios`：封装统一请求拦截、Token 处理与异常提示。
7. `Apache ECharts`：展示任务趋势、指标对比、数据分布和训练结果。

### 4.2 后端技术栈

1. `Java 17`：LTS 版本，适合企业级项目开发。
2. `Spring Boot 3.x`：快速构建 REST 服务与模块化应用。
3. `Spring Security`：实现登录认证、权限校验和接口保护。
4. `MyBatis Plus`：简化持久层开发，提高 CRUD 效率。
5. `MySQL`：存储系统管理数据、任务配置、指标结果和审计日志。
6. `Lombok`：减少样板代码。
7. `Knife4j / Swagger`：生成接口文档，便于联调与答辩展示。
8. `Hutool`：辅助处理日期、集合、文件、JSON 与加密工具类。

### 4.3 联邦计算技术栈

1. `FATE`：联邦学习核心框架。
2. `FATE Flow`：负责联邦任务提交、执行与状态查询。
3. `FATE Pipeline`：通过 Python 脚本化方式编排联邦训练流程。
4. `PSI`：完成隐私集合求交，实现跨机构样本对齐。
5. `Hetero Logistic Regression`：适用于二分类信用风险预测。
6. `Hetero SecureBoost`：适用于非线性特征关系的提升树建模。

### 4.4 部署与运维技术

1. `Docker`：简化环境安装与运行隔离。
2. `Docker Compose`：统一编排前端、后端、MySQL、FATE Standalone 容器。
3. `Nginx`：可选，用于反向代理前端静态资源和后端接口。

### 4.5 选型理由总结

本项目选型兼顾了三点：一是符合主流企业项目开发习惯，二是能真实接入 FATE 联邦能力，三是能控制毕业设计实施复杂度。前后端技术成熟，便于快速落地；FATE 具备代表性与可解释性；Docker 化部署便于复现实验环境。

## 5. 系统总体架构

系统采用“前端展示层 + 后端业务层 + 联邦计算适配层 + 多方数据节点层 + 基础设施层”的分层架构。

### 5.1 展示层

面向管理员、机构用户和审计用户提供统一 Web 门户，支持登录、数据资产管理、样本对齐、联邦任务创建、训练监控、模型评估和日志查询。

### 5.2 业务层

基于 Spring Boot 构建业务中台，负责用户权限、机构管理、任务编排、配置校验、结果持久化、日志审计和指标聚合，是整个平台的控制中心。

### 5.3 联邦计算适配层

封装 FATE Pipeline、本地脚本模拟器和 FATE Flow API 调用逻辑，对外提供统一的联邦任务提交接口。该层负责将平台任务配置转换为 FATE 可执行流程，并解析任务状态、训练日志和模型指标。

### 5.4 多方数据节点层

银行侧与运营商侧分别保留本地数据文件或本地数据表，仅在 PSI 和联邦训练过程中参与安全计算。原始特征、标签和明文样本不上传至平台数据库。

### 5.5 基础设施层

包括 MySQL、Docker、FATE Standalone、日志文件、配置中心和可选 Nginx。MySQL 仅保存平台元数据、任务配置和结果，不保存参与方原始业务明文数据。

## 6. 系统架构图（文字版）

```text
+-----------------------------------------------------------------------------------+
|                                  前端展示层                                       |
| Vue3 + Vite + Element Plus + Pinia + Router + Axios + ECharts                    |
| 首页看板 | 用户权限 | 机构管理 | 数据资产 | 样本对齐 | 联邦建模 | 评估报告 | 审计日志 |
+-----------------------------------------|-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                                  后端业务层                                       |
| Spring Boot 3.x                                                                    |
| Auth模块 | 机构模块 | 数据资产模块 | PSI任务模块 | 联邦任务模块 | 评估模块 | 审计模块 |
| REST API | 权限控制 | 参数校验 | 任务调度 | 状态聚合 | 结果回写 | 文档接口           |
+-----------------------------------------|-----------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                              联邦计算适配层                                       |
| FATE Adapter Service                                                               |
| 1. 模拟脚本执行器                                                                  |
| 2. FATE Pipeline 脚本生成与执行                                                    |
| 3. FATE Flow API / CLI 提交                                                        |
| 4. 状态查询、日志解析、指标提取                                                    |
+-----------------------------|-------------------------------|----------------------+
                              |                               |
                              v                               v
+-----------------------------------------+   +-------------------------------------+
|          银行本地节点                    |   |          运营商本地节点              |
| 客户基础信息/征信/贷款/逾期标签          |   | 通信行为/套餐消费/在网时长/欠费次数   |
| 本地样本ID、特征、标签不出域             |   | 本地样本ID、特征不出域               |
+-----------------------------|-----------+   +--------------------|----------------+
                              |                                    |
                              +--------------- PSI ----------------+
                                              |
                                              v
                                    联邦建模安全计算

+-----------------------------------------------------------------------------------+
|                                  基础设施层                                       |
| MySQL | Docker | Docker Compose | FATE Standalone | Nginx(Optional)               |
+-----------------------------------------------------------------------------------+
```

## 7. 核心功能模块设计

以下模块均围绕“平台化联邦建模”展开，强调任务闭环、权限边界和工程落地。

### 7.1 用户登录与权限管理

**模块目标**

为平台用户提供身份认证、角色授权、菜单控制和接口访问控制，确保不同角色仅能访问授权功能与数据。

**输入数据**

用户名、密码、角色信息、机构归属、账号状态。

**处理流程**

1. 用户通过登录页提交账号密码。
2. 后端使用 Spring Security 进行认证。
3. 认证成功后签发 JWT Token。
4. 前端缓存 Token 和用户信息。
5. 后端依据角色和权限编码进行接口鉴权。

**输出结果**

登录 Token、用户基本信息、角色列表、菜单权限树。

**涉及数据库表**

`sys_user`、`sys_role`、`sys_permission`、`sys_user_role`、`sys_role_permission`

**涉及核心接口**

`POST /api/auth/login`
`GET /api/auth/me`
`GET /api/auth/menus`
`POST /api/users`
`PUT /api/users/{id}/status`

**实现注意事项**

1. 密码需使用 BCrypt 加密存储。
2. 接口层与菜单层权限要分离设计。
3. 用户必须绑定机构，便于联邦任务隔离。
4. 管理员、机构操作员、审计员角色建议分层定义。

### 7.2 机构管理

**模块目标**

维护参与联邦建模的机构主体信息，明确银行方、运营商方及其 partyId、负责人、网络配置和状态。

**输入数据**

机构名称、机构编码、机构类型、partyId、联系人、节点地址、状态。

**处理流程**

1. 管理员新增或编辑机构信息。
2. 校验机构编码、partyId 唯一性。
3. 保存机构与联邦节点映射关系。
4. 在任务创建时根据机构信息自动装配参与方配置。

**输出结果**

机构列表、机构详情、可用机构下拉数据。

**涉及数据库表**

`org_info`、`org_node_config`

**涉及核心接口**

`GET /api/orgs`
`POST /api/orgs`
`PUT /api/orgs/{id}`
`GET /api/orgs/options`

**实现注意事项**

1. 机构类型应区分 guest、host、arbiter 或演示角色。
2. partyId 需与 FATE 实际配置保持一致。
3. 节点地址、命名空间、数据源配置建议独立表管理。

### 7.3 数据资产管理

**模块目标**

管理联邦参与方的数据资产元信息，包括数据集名称、所属机构、字段说明、主键标识、标签说明、数据状态和上传时间，但不接收原始明文业务数据入库。

**输入数据**

数据集名称、文件路径或数据源标识、所属机构、样本主键字段、标签字段、字段清单、记录数、更新时间。

**处理流程**

1. 机构用户登记本地数据集元信息。
2. 后端解析字段说明或导入模板。
3. 对数据集进行状态校验，如字段完整性、主键存在性、标签合法性。
4. 训练任务创建时选择数据资产作为输入来源。

**输出结果**

数据资产列表、字段预览、数据状态、可选训练数据集。

**涉及数据库表**

`data_asset`、`data_asset_field`、`data_asset_version`

**涉及核心接口**

`GET /api/data-assets`
`POST /api/data-assets`
`GET /api/data-assets/{id}`
`GET /api/data-assets/{id}/fields`

**实现注意事项**

1. 平台只保存元信息和字段说明，不保存原始业务记录。
2. 支持 CSV 文件路径、数据库表名或 FATE 命名空间等多种标识方式。
3. 字段设计需区分主键、标签、数值特征、类别特征。

### 7.4 样本对齐

**模块目标**

基于 PSI 实现银行与运营商的样本 ID 安全对齐，得到可用于纵向联邦建模的交集样本集合。

**输入数据**

参与机构、数据集标识、样本主键字段、PSI 参数、任务名称。

**处理流程**

1. 用户选择双方数据资产并发起样本对齐任务。
2. 后端生成 PSI 任务配置。
3. 第一阶段由本地脚本模拟交集计算。
4. 第二阶段使用 FATE PSI 流程执行安全集合求交。
5. 平台保存对齐数量、成功状态和输出位置。

**输出结果**

对齐任务编号、交集样本量、任务状态、对齐结果摘要。

**涉及数据库表**

`psi_task`、`psi_task_party`、`psi_task_result`

**涉及核心接口**

`POST /api/psi/tasks`
`GET /api/psi/tasks`
`GET /api/psi/tasks/{id}`
`GET /api/psi/tasks/{id}/result`

**实现注意事项**

1. 对齐结果应仅保存数量、文件引用或命名空间，不保存交集明文 ID 到平台数据库。
2. 任务创建前需校验双方主键字段类型一致。
3. 对齐任务与建模任务应建立依赖关系。

### 7.5 联邦建模任务管理

**模块目标**

统一管理联邦训练任务的创建、配置、提交、暂停、重试、查询和结果回写，支持 Hetero LR 与 Hetero SecureBoost。

**输入数据**

任务名称、任务类型、算法类型、参与机构、关联 PSI 任务、特征配置、超参数配置、数据集版本。

**处理流程**

1. 用户填写任务基本信息和算法参数。
2. 后端校验数据依赖是否齐全。
3. 生成平台侧任务记录，状态置为“待提交”。
4. 调用联邦适配层执行真实任务或模拟任务。
5. 定时同步训练状态、指标结果和模型摘要。

**输出结果**

任务编号、任务状态、算法配置、训练结果、失败原因。

**涉及数据库表**

`federated_task`、`federated_task_party`、`federated_task_param`、`federated_task_result`

**涉及核心接口**

`POST /api/federated/tasks`
`GET /api/federated/tasks`
`GET /api/federated/tasks/{id}`
`POST /api/federated/tasks/{id}/submit`
`POST /api/federated/tasks/{id}/retry`

**实现注意事项**

1. 任务状态建议细化为待创建、待提交、运行中、成功、失败、已取消。
2. 算法参数建议 JSON 化存储，便于扩展不同模型。
3. 建模任务应支持实验对比，保留单方与联邦任务类型。

### 7.6 FATE 任务调用

**模块目标**

将平台任务配置转换为 FATE 可执行命令、Pipeline 脚本或 Flow API 请求，实现联邦训练真正落地。

**输入数据**

任务 ID、算法类型、partyId、数据集引用、FATE 配置模板、运行模式。

**处理流程**

1. 适配层读取任务配置。
2. 根据阶段选择模拟执行、本地 Pipeline 执行或 Flow API 提交。
3. 记录提交时间、外部任务 ID、命令信息。
4. 异步查询运行状态并回写数据库。

**输出结果**

FATE jobId、运行日志、任务状态、外部响应报文。

**涉及数据库表**

`fate_job_mapping`、`task_runtime_log`

**涉及核心接口**

`POST /api/fate/jobs/submit`
`GET /api/fate/jobs/{taskId}/status`
`GET /api/fate/jobs/{taskId}/logs`

**实现注意事项**

1. 应将 FATE 适配逻辑与业务服务解耦，避免控制层直接拼接命令。
2. 建议引入脚本模板目录，统一生成 Pipeline 运行脚本。
3. 外部调用异常必须结构化落库，便于排查。

### 7.7 训练状态监控

**模块目标**

实时展示任务运行状态、阶段进度、执行耗时和异常信息，提升平台可观测性。

**输入数据**

平台任务 ID、外部 jobId、定时拉取结果、日志摘要。

**处理流程**

1. 定时任务轮询 FATE Flow 或本地执行结果。
2. 将运行状态映射为平台统一状态。
3. 提取开始时间、结束时间、耗时、阶段日志。
4. 前端轮询或 WebSocket 刷新展示。

**输出结果**

状态标签、进度信息、时间轴、异常信息、耗时统计。

**涉及数据库表**

`task_runtime_snapshot`、`task_runtime_log`

**涉及核心接口**

`GET /api/tasks/{id}/runtime`
`GET /api/tasks/{id}/timeline`
`GET /api/tasks/{id}/logs`

**实现注意事项**

1. 轮询频率需平衡实时性与系统压力。
2. 要区分平台状态和 FATE 原始状态。
3. 失败时要展示最后一次有效错误日志。

### 7.8 模型评估报告

**模块目标**

展示训练后模型的关键指标、模型对比、图表结果和实验结论，为项目分析和论文撰写提供依据。

**输入数据**

训练结果、验证集指标、混淆矩阵、AUC 曲线数据、Loss 曲线数据、实验标签。

**处理流程**

1. 解析 FATE 输出指标或模拟结果文件。
2. 对指标进行标准化映射。
3. 写入数据库并生成评估报告。
4. 前端使用图表展示模型效果与对比结果。

**输出结果**

Accuracy、Precision、Recall、F1-score、AUC、KS、Loss，以及图表化分析报告。

**涉及数据库表**

`model_report`、`model_metric`、`model_curve_data`

**涉及核心接口**

`GET /api/reports/{taskId}/summary`
`GET /api/reports/{taskId}/metrics`
`GET /api/reports/{taskId}/curves`
`GET /api/reports/compare`

**实现注意事项**

1. 指标字段建议标准化命名，便于不同算法统一展示。
2. 曲线数据建议以 JSON 存储。
3. 报告页面应支持单任务查看和多任务对比。

### 7.9 审计日志

**模块目标**

记录平台关键操作、敏感访问、任务执行、异常事件和安全行为，为答辩展示、问题追踪和合规审计提供依据。

**输入数据**

操作人、角色、机构、模块、接口路径、请求参数摘要、结果状态、IP、耗时。

**处理流程**

1. 通过 AOP 或过滤器拦截关键请求。
2. 提取用户信息、操作类型和接口结果。
3. 对敏感字段进行脱敏。
4. 异步写入日志表。

**输出结果**

审计日志记录、操作追踪明细、异常事件清单。

**涉及数据库表**

`audit_log`、`login_log`

**涉及核心接口**

`GET /api/audit/logs`
`GET /api/audit/logs/{id}`
`GET /api/audit/login-logs`

**实现注意事项**

1. 日志不能记录明文密码、完整身份证号等敏感信息。
2. 任务提交、状态变更、权限变更必须重点留痕。
3. 大字段日志建议截断存储并保留摘要。

### 7.10 首页数据看板

**模块目标**

从平台运营和实验展示两个维度，集中呈现机构数量、数据资产数量、任务趋势、成功率、模型效果对比和最近操作情况。

**输入数据**

机构统计、资产统计、任务统计、评估指标、日志统计。

**处理流程**

1. 后端聚合首页统计数据。
2. 前端加载卡片、折线图、柱状图和饼图。
3. 支持时间筛选和任务类型筛选。

**输出结果**

数据卡片、趋势图、实验对比图、任务列表。

**涉及数据库表**

聚合查询多个业务表，主要包括 `org_info`、`data_asset`、`federated_task`、`model_report`、`audit_log`

**涉及核心接口**

`GET /api/dashboard/overview`
`GET /api/dashboard/task-trend`
`GET /api/dashboard/model-compare`
`GET /api/dashboard/recent-activities`

**实现注意事项**

1. 首页接口应聚合优化，避免前端发起过多请求。
2. 指标要兼顾业务展示和实验展示。
3. 可增加“原始数据不出域”说明区域，强化项目价值表达。

## 8. 数据库总体设计

### 8.1 设计原则

1. 平台数据库只保存系统元数据、任务配置、运行结果和日志。
2. 不保存银行与运营商的原始业务明文数据。
3. 任务参数与评估指标采用结构化表 + JSON 扩展字段结合方式。
4. 通过逻辑主键和业务唯一键确保任务可追踪。

### 8.2 核心实体划分

1. 用户权限域：用户、角色、权限、用户角色关系、角色权限关系。
2. 机构域：机构信息、节点配置。
3. 数据资产域：数据资产、字段定义、版本记录。
4. 联邦任务域：PSI 任务、建模任务、任务参与方、参数、结果、运行快照。
5. 评估域：模型报告、指标、曲线数据。
6. 审计域：审计日志、登录日志。

### 8.3 关键表设计建议

#### 8.3.1 用户与权限

`sys_user(id, username, password, real_name, org_id, status, created_at, updated_at)`

`sys_role(id, role_code, role_name, status)`

`sys_permission(id, perm_code, perm_name, perm_type, path, method)`

`sys_user_role(id, user_id, role_id)`

`sys_role_permission(id, role_id, permission_id)`

#### 8.3.2 机构与节点

`org_info(id, org_code, org_name, org_type, party_id, contact_person, contact_phone, status, remark)`

`org_node_config(id, org_id, node_host, node_port, data_namespace, fate_version, config_json)`

#### 8.3.3 数据资产

`data_asset(id, asset_code, asset_name, org_id, asset_type, source_type, source_ref, id_field, label_field, sample_count, status, version_no, created_by, created_at)`

`data_asset_field(id, asset_id, field_name, field_type, field_role, nullable_flag, description)`

`data_asset_version(id, asset_id, version_no, source_ref, checksum, created_at)`

#### 8.3.4 样本对齐

`psi_task(id, task_code, task_name, guest_org_id, host_org_id, status, id_field, submit_time, finish_time, result_ref, intersect_count, error_msg)`

`psi_task_party(id, psi_task_id, org_id, role_type, asset_id, party_id)`

`psi_task_result(id, psi_task_id, result_ref, result_type, summary_json)`

#### 8.3.5 联邦建模任务

`federated_task(id, task_code, task_name, task_mode, algorithm_type, psi_task_id, status, submit_type, external_job_id, created_by, created_at, submit_time, finish_time, error_msg)`

`federated_task_party(id, task_id, org_id, role_type, asset_id, party_id, has_label)`

`federated_task_param(id, task_id, param_type, param_json)`

`federated_task_result(id, task_id, model_name, model_version, metric_summary_json, artifact_ref, report_status)`

`fate_job_mapping(id, task_id, external_job_id, job_type, submit_payload, response_payload, last_sync_time)`

`task_runtime_snapshot(id, task_id, runtime_status, progress_stage, progress_percent, snapshot_time, detail_json)`

`task_runtime_log(id, task_id, log_level, log_time, content)`

#### 8.3.6 模型评估

`model_report(id, task_id, report_name, dataset_type, accuracy, precision_rate, recall_rate, f1_score, auc, ks, loss, summary_text)`

`model_metric(id, report_id, metric_name, metric_value, metric_group)`

`model_curve_data(id, report_id, curve_type, curve_json)`

#### 8.3.7 审计日志

`audit_log(id, user_id, username, org_id, module_name, operation_type, request_uri, request_method, request_param, response_code, success_flag, cost_ms, ip, created_at)`

`login_log(id, username, success_flag, failure_reason, ip, user_agent, created_at)`

### 8.4 索引设计建议

1. 所有任务表对 `task_code`、`status`、`created_at` 建索引。
2. 外部任务映射表对 `external_job_id` 建唯一索引。
3. 审计日志对 `user_id`、`module_name`、`created_at` 建组合索引。
4. 数据资产表对 `org_id + asset_code` 建唯一索引。

## 9. REST API 接口总体设计

### 9.1 设计原则

1. 统一采用 REST 风格。
2. 返回结构统一封装为 `code`、`message`、`data`。
3. 重要操作需要记录审计日志。
4. 需要分页的列表接口统一使用 `pageNum`、`pageSize`。
5. 长耗时联邦任务采用“提交即返回任务号 + 异步查询状态”模式。

### 9.2 接口分组

#### 9.2.1 认证与用户

`POST /api/auth/login`
`POST /api/auth/logout`
`GET /api/auth/me`
`GET /api/users`
`POST /api/users`
`PUT /api/users/{id}`
`PUT /api/users/{id}/password`

#### 9.2.2 机构管理

`GET /api/orgs`
`POST /api/orgs`
`PUT /api/orgs/{id}`
`GET /api/orgs/{id}`

#### 9.2.3 数据资产

`GET /api/data-assets`
`POST /api/data-assets`
`GET /api/data-assets/{id}`
`GET /api/data-assets/{id}/fields`
`POST /api/data-assets/{id}/validate`

#### 9.2.4 样本对齐

`POST /api/psi/tasks`
`GET /api/psi/tasks`
`GET /api/psi/tasks/{id}`
`GET /api/psi/tasks/{id}/result`

#### 9.2.5 联邦建模

`POST /api/federated/tasks`
`GET /api/federated/tasks`
`GET /api/federated/tasks/{id}`
`POST /api/federated/tasks/{id}/submit`
`POST /api/federated/tasks/{id}/retry`
`GET /api/federated/tasks/{id}/runtime`

#### 9.2.6 模型评估

`GET /api/reports/{taskId}/summary`
`GET /api/reports/{taskId}/metrics`
`GET /api/reports/{taskId}/curves`
`GET /api/reports/compare`

#### 9.2.7 审计与看板

`GET /api/audit/logs`
`GET /api/audit/login-logs`
`GET /api/dashboard/overview`
`GET /api/dashboard/task-trend`
`GET /api/dashboard/model-compare`

### 9.3 示例返回结构

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "taskId": 1001,
    "status": "RUNNING"
  }
}
```

### 9.4 接口设计注意事项

1. 提交类接口必须做幂等控制，避免重复发起同一任务。
2. 任务提交与状态同步建议分离，防止长事务阻塞。
3. 所有查询接口应根据用户所属机构做数据隔离。

## 10. FATE 调用流程设计

FATE 接入按照“三阶段逐步演进”方式设计，以控制项目实施风险，并保证平台功能能够先闭环、再真实接入、再自动化集成。

### 10.1 第一阶段：模拟数据 + 本地脚本闭环

**目标**

先完成平台业务闭环，验证页面、接口、任务流转、状态回写和报告展示。

**实现方式**

1. 使用银行与运营商模拟 CSV 数据。
2. 平台保存任务配置后，调用本地 Python 脚本或 Java 模拟服务。
3. 脚本模拟 PSI 结果、训练耗时、训练状态和指标输出。
4. 后端解析模拟结果文件并写入 MySQL。

**收益**

1. 前后端功能可先联调成功。
2. 不依赖复杂 FATE 环境即可完成项目初版。
3. 适合早期开发、页面展示和答辩演示。

### 10.2 第二阶段：接入 FATE Standalone + FATE Pipeline

**目标**

将模拟流程升级为真实联邦训练流程。

**实现方式**

1. 部署 FATE Standalone 环境。
2. 准备 guest 与 host 的本地数据配置。
3. 使用 FATE Pipeline 编写联邦流程脚本。
4. 串联 Reader、DataTransform、Intersection、HeteroLR 或 HeteroSecureBoost、Evaluation 等组件。
5. 平台通过命令行触发 Pipeline 脚本执行。

**推荐 Pipeline 流程**

1. 读取银行方训练数据与运营商方训练数据。
2. 执行 PSI / Intersection 完成样本对齐。
3. 数据转换与特征预处理。
4. 执行 Hetero Logistic Regression 或 Hetero SecureBoost。
5. 输出训练与评估结果。

**收益**

1. 联邦训练过程真实可运行。
2. 能体现平台对 FATE 的工程化集成能力。
3. 适合论文中展示实际联邦建模流程。

### 10.3 第三阶段：FATE Flow API / CLI 自动化提交与状态回写

**目标**

将 FATE 运行能力彻底平台化，实现自动任务编排与结果接入。

**实现方式**

1. 后端生成 FATE Flow 提交配置或命令参数。
2. 调用 FATE Flow API 或 CLI 提交任务。
3. 获取外部 `jobId` 并保存到 `fate_job_mapping`。
4. 定时轮询任务状态。
5. 拉取训练日志、评估指标、模型摘要。
6. 解析后回写 `federated_task_result`、`model_report` 等表。

### 10.4 平台侧任务时序

```text
前端创建任务
    ->
后端保存任务配置
    ->
调用 FATE 适配层
    ->
生成 Pipeline/Flow 请求
    ->
提交 FATE 任务
    ->
返回 externalJobId
    ->
定时轮询状态
    ->
解析训练指标与日志
    ->
写入 MySQL
    ->
前端展示运行状态与评估报告
```

### 10.5 关键实现点

1. Java 后端不直接实现模型训练，而是做联邦任务编排与控制。
2. 建议通过独立脚本目录管理 Pipeline 脚本模板。
3. FATE 返回结果需做平台标准化映射，便于前端统一展示。
4. 原始数据仍保留在各参与方本地，平台只处理任务元数据和结果摘要。

## 11. 前端页面设计

### 11.1 页面总体结构

采用后台管理系统布局，包含顶部导航、左侧菜单、主内容区和面包屑导航。

### 11.2 主要页面清单

1. 登录页
2. 首页数据看板
3. 用户与角色管理页
4. 机构管理页
5. 数据资产列表页
6. 数据资产详情页
7. 样本对齐任务列表页
8. 创建样本对齐任务页
9. 联邦建模任务列表页
10. 创建联邦建模任务页
11. 训练状态监控页
12. 模型评估报告页
13. 审计日志页

### 11.3 页面设计要点

#### 11.3.1 登录页

展示平台名称、项目简介、账号密码输入框，支持登录校验与错误提示。

#### 11.3.2 首页看板

展示机构数量、数据资产数量、运行中任务数、任务成功率、最新实验结果、单方与联邦模型 AUC 对比图、任务趋势图。

#### 11.3.3 数据资产页面

展示数据集元信息、字段列表、数据状态和版本信息。通过表格和抽屉页展示字段角色，例如主键、标签、数值特征、类别特征。

#### 11.3.4 样本对齐页面

支持选择 guest 与 host 数据资产、主键字段、任务名称，展示 PSI 任务状态、交集样本量和运行时间。

#### 11.3.5 联邦建模页面

支持选择算法类型、任务模式、参与机构、关联对齐任务、参数配置。使用步骤条展示“任务创建 -> 提交 -> 训练 -> 报告生成”。

#### 11.3.6 训练监控页面

展示任务状态、FATE jobId、时间轴、日志窗口和阶段进度，可按秒级或固定间隔刷新。

#### 11.3.7 评估报告页面

展示 Accuracy、Precision、Recall、F1-score、AUC、KS、Loss 指标卡片，以及 ROC 曲线、Loss 曲线、对比柱状图。

#### 11.3.8 审计日志页面

支持按用户、模块、时间范围、结果状态筛选关键操作记录。

### 11.4 前端工程建议

1. API 按模块拆分为 `auth.ts`、`org.ts`、`asset.ts`、`psi.ts`、`task.ts`、`report.ts`。
2. 使用 Pinia 存储用户状态、菜单权限和首页统计。
3. 对任务状态使用枚举统一映射颜色与文案。
4. 图表组件可封装为通用卡片，便于复用。

## 12. 安全与权限设计

### 12.1 安全设计目标

1. 保障平台账户与接口安全。
2. 保障机构之间的数据访问隔离。
3. 保障联邦任务提交过程可控可追踪。
4. 强调原始数据不出域的设计原则。

### 12.2 认证与授权

1. 使用 Spring Security + JWT 实现无状态认证。
2. 用户登录后签发 Token，接口访问基于 Token 鉴权。
3. 采用 RBAC 权限模型控制菜单和接口访问。
4. 管理员可以查看全局数据，机构用户仅查看本机构数据，审计员只读访问。

### 12.3 数据安全设计

1. 原始业务数据只保留在银行和运营商本地。
2. 平台数据库不落用户明文特征与标签。
3. 样本对齐仅输出交集结果引用或统计摘要。
4. 日志和接口中对敏感字段进行脱敏。

### 12.4 接口安全设计

1. 登录接口增加失败次数限制或验证码扩展点。
2. 所有写操作接口增加权限校验。
3. 关键操作记录操作人、时间和参数摘要。
4. 对任务提交接口进行参数白名单校验，防止脚本注入。

### 12.5 配置与部署安全

1. 敏感配置放入环境变量或独立配置文件。
2. 数据库、FATE 接入配置分环境管理。
3. Docker 容器仅暴露必要端口。
4. 可通过 Nginx 做 HTTPS 反向代理。

## 13. 审计日志设计

### 13.1 日志分类

1. 登录日志：记录登录成功、失败、来源 IP、终端信息。
2. 操作日志：记录增删改查、任务提交、权限变更等行为。
3. 任务日志：记录联邦任务创建、提交、同步、失败重试。
4. 安全日志：记录越权访问、Token 失效、异常请求等事件。

### 13.2 记录字段

建议包含：日志类型、模块名称、操作类型、用户名、机构、请求路径、请求方式、参数摘要、响应状态、耗时、IP、时间。

### 13.3 实现方式

1. 登录日志通过认证成功/失败处理器记录。
2. 操作日志通过 AOP 切面记录。
3. 联邦任务运行日志由适配层和定时同步任务写入。
4. 可采用异步线程池降低主流程性能影响。

### 13.4 应用价值

1. 支撑系统问题追踪。
2. 满足毕业设计中“可审计、可追责”的平台设计要求。
3. 强化平台工程属性，而非简单算法脚本。

## 14. 部署方案

### 14.1 部署拓扑

建议采用单机 Docker Compose 演示部署，适合课程设计和毕业设计答辩环境。

```text
宿主机
|- mysql
|- backend-springboot
|- frontend-nginx
|- fate-standalone
|- optional-nginx-gateway
```

### 14.2 部署组成

1. MySQL 容器：保存平台元数据、任务结果和日志。
2. Spring Boot 容器：提供后台 API。
3. Vue 前端容器：提供静态页面。
4. FATE Standalone 容器：提供联邦训练运行环境。
5. Nginx 容器：可选，用于统一入口与静态资源代理。

### 14.3 环境建议

1. 操作系统：Linux 或 Windows + Docker Desktop。
2. JDK：17。
3. Python：用于 Pipeline 脚本执行。
4. Docker Compose：统一管理运行环境。

### 14.4 部署步骤建议

1. 启动 MySQL 并初始化表结构。
2. 启动 FATE Standalone 环境。
3. 部署 Spring Boot 后端。
4. 打包并部署 Vue 前端。
5. 配置前端代理与后端跨域。
6. 执行模拟任务或真实联邦任务验证联通性。

### 14.5 配置文件建议

1. `application-dev.yml`：本地开发配置。
2. `application-prod.yml`：容器部署配置。
3. `docker-compose.yml`：统一编排服务。
4. `fate-scripts/`：存放 Pipeline 与 Flow 调用脚本。

## 15. 实验方案

实验目标是比较单方建模与联邦联合建模的效果差异，验证联邦学习的业务价值。

### 15.1 实验分组

#### 实验一：银行单方训练

使用银行方基础信息、信用记录、贷款记录和标签进行单方训练，作为基线模型。

#### 实验二：运营商单方训练

使用运营商方通信行为、套餐消费、在网时长、欠费次数等特征进行单方训练。由于运营商一般不持有逾期标签，可在实验模拟中使用对齐后的标签映射进行单方评估，主要用于特征贡献对比。

#### 实验三：银行 + 运营商联邦联合训练

基于 PSI 获取交集样本后，使用纵向联邦学习完成联合建模，比较与单方模型的提升幅度。

### 15.2 实验流程

1. 准备模拟数据集并进行字段整理。
2. 分别登记银行和运营商数据资产。
3. 执行样本对齐任务。
4. 创建银行单方、运营商单方、联邦联合训练三类任务。
5. 运行训练并生成评估报告。
6. 对比实验结果并分析联邦学习收益。

### 15.3 评价指标

1. Accuracy
2. Precision
3. Recall
4. F1-score
5. AUC
6. KS
7. Loss

### 15.4 结果分析维度

1. 联邦模型相较于单方模型的 AUC 提升。
2. 不同算法在联邦场景下的表现差异。
3. PSI 后样本规模变化对模型效果的影响。
4. 训练耗时与工程复杂度分析。

### 15.5 实验预期结论

在数据不出域条件下，联邦联合训练通常优于单方训练，尤其在 AUC、Recall 和 KS 等风控核心指标上更具优势，说明多方特征互补对信用风险识别具有显著价值。

## 16. 项目开发计划

建议采用 6 周到 8 周的节奏推进。

### 第一阶段：需求分析与架构设计

1. 明确业务场景和模块边界。
2. 完成技术选型与数据库设计。
3. 输出原型图和技术架构文档。

### 第二阶段：基础平台开发

1. 完成登录认证、权限管理、机构管理。
2. 完成数据资产管理与首页看板基础能力。
3. 联调前后端基本框架。

### 第三阶段：联邦任务闭环开发

1. 完成 PSI 任务管理、建模任务管理、训练状态监控。
2. 接入模拟脚本，形成闭环。
3. 完成评估报告和审计日志模块。

### 第四阶段：FATE 真实接入

1. 部署 FATE Standalone。
2. 编写 Pipeline 脚本。
3. 接入 FATE Flow API 或 CLI。
4. 打通状态同步与结果回写。

### 第五阶段：实验与优化

1. 完成三组实验。
2. 优化界面展示、日志说明和异常处理。
3. 输出论文图表和总结材料。

## 17. 项目亮点与创新点

1. **平台化设计而非脚本 Demo**：项目包含用户、机构、数据资产、任务、报告、审计等完整系统能力。
2. **强调数据不出域**：平台仅管理元数据与结果，原始业务数据保留在参与方本地。
3. **联邦任务分阶段落地**：从模拟闭环到 FATE Standalone 再到 Flow API 集成，实施路径清晰、风险可控。
4. **兼顾技术深度与工程可实现性**：既体现 PSI、HeteroLR、HeteroSecureBoost 等联邦能力，也体现后端架构、接口设计和部署方案。
5. **适合论文与答辩展示**：具备文字架构图、模块设计、数据库设计、实验方案和指标体系，便于直接写入毕业设计文档。
6. **具有扩展潜力**：后续可扩展到医疗联合诊断、政务联合风控、电商联合营销等多场景。

## 18. 总结

本项目围绕“基于 FATE 的多方数据安全联合建模平台”展开，以银行与运营商信用风险预测为典型案例，设计了一个兼具平台化、工程化和可落地性的联邦计算系统。系统以前后端分离架构为基础，以 Spring Boot 为业务中台，以 FATE 为联邦训练引擎，围绕用户权限、机构管理、数据资产、PSI 对齐、联邦建模、训练监控、模型评估和审计日志构建完整闭环。

相较于单纯描述算法流程的方案，本设计重点突出以下价值：一是原始数据不出域，符合隐私保护要求；二是任务、日志、结果和权限统一管理，具备平台属性；三是采用分阶段接入 FATE 的实施策略，兼顾项目可交付性与真实技术深度。该方案既可作为毕业设计系统实现蓝本，也适合在简历中体现“隐私计算 + Java 后端 + 平台工程”的综合能力。
