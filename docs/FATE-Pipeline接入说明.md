# FATE Pipeline 接入说明

## 当前接入状态

后端已经支持三种执行模式：

```text
MOCK
FATE_PIPELINE
FATE_FLOW_API
```

当前已实现真实 `FATE_PIPELINE` 调用分支。平台提交联邦任务时，如果任务 `submitType` 为 `FATE_PIPELINE`，后端会调用 `backend/fate-scripts/` 下的 Python Pipeline 脚本。

## 脚本位置

```text
backend/fate-scripts/hetero_lr_pipeline_template.py
backend/fate-scripts/hetero_secureboost_pipeline_template.py
```

两个脚本均使用 FATE Pipeline SDK，包含：

```text
Reader
DataTransform
Intersection
HeteroLR / HeteroSecureBoost
Evaluation
```

## 后端启动参数

```powershell
$env:FATE_MODE='FATE_PIPELINE'
$env:FATE_SCRIPTS_DIR='D:/联邦学习/demo-project1/backend/fate-scripts'
$env:FATE_PIPELINE_PYTHON='python'
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=dev-h2
```

如果使用 MySQL：

```powershell
$env:DB_URL='jdbc:mysql://localhost:3306/fate_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false'
$env:DB_USERNAME='root'
$env:DB_PASSWORD='你的MySQL密码'
$env:FATE_MODE='FATE_PIPELINE'
$env:FATE_SCRIPTS_DIR='D:/联邦学习/demo-project1/backend/fate-scripts'
.\mvnw.cmd spring-boot:run
```

## FATE 环境要求

运行真实 Pipeline 前，需要当前 Python 环境可导入：

```python
pipeline
```

可用以下命令检查：

```powershell
python -c "import importlib.util; print(importlib.util.find_spec('pipeline'))"
```

如果返回 `None`，说明当前 Python 环境尚未安装或激活 FATE Pipeline SDK。

当前机器使用的是 Python 3.6.5。已通过以下方式安装 FATE Pipeline SDK：

```powershell
python -m pip install ruamel.yaml.clib==0.2.2 -i https://pypi.org/simple
python -m pip install ruamel.yaml==0.16.13 --ignore-installed --no-deps -i https://pypi.org/simple
python -m pip install requests_toolbelt==0.9.1 loguru==0.5.3 flask==1.1.4 click==7.1.2 Werkzeug==1.0.1 itsdangerous==1.1.0 Jinja2==2.11.3 aiocontextvars==0.2.2 win32-setctime==1.2.0 setuptools==50.3.2 --no-deps -i https://pypi.org/simple
python -m pip install fate-client --no-deps -i https://pypi.org/simple
```

安装完成后初始化 Pipeline 连接配置：

```powershell
pipeline init --ip 127.0.0.1 --port 9380 --log-directory D:/联邦学习/demo-project1/backend/fate-scripts/logs --system-user guest
```

如果 FATE Flow 未启动，真实 Pipeline 任务会提交失败，并在运行日志中出现类似：

```text
HTTPConnectionPool(host='127.0.0.1', port=9380) ... Failed to establish a new connection
```

这表示 SDK 和脚本已进入真实提交流程，但本机没有可连接的 FATE Flow 服务。

## 数据资产 source_ref 格式

平台中的 `data_asset.source_ref` 需要使用：

```text
namespace.table
```

示例：

```text
bank_credit_risk.bank_train_v1
operator_credit_risk.operator_train_v1
```

后端会自动拆分为 FATE Pipeline 中 Reader 组件需要的：

```text
namespace
table name
```

## 任务执行结果

Pipeline 成功后，脚本会输出：

```text
FATE_JOB_ID=<job_id>
```

后端会解析该值并写回 `federated_task.external_job_id`，同时写入运行日志和一条基础模型报告记录。后续可以继续扩展 FATE Flow API 同步指标解析逻辑。
