# 基于 FATE 的多方数据安全联合建模平台

这是一个前后端分离的联邦建模平台 MVP，实现银行与运营商信用风险预测场景下的样本对齐、联邦建模、训练监控、模型评估、审计日志和首页看板。

## 目录结构

```text
backend/   Spring Boot 3 后端
frontend/  Vue 3 + Vite 前端
deploy/    Docker Compose 部署文件
docs/      预留项目说明文档目录
```

## 默认账号

```text
admin / 123456
```

## 本地开发

启动 MySQL 后运行后端：

```powershell
cd backend
mvn spring-boot:run
```

如果本机 MySQL 密码不确定，可以先用内置 H2 开发库运行后端：

```powershell
cd backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=dev-h2
```

本机未安装 Maven 时，可使用后端目录内的轻量 Maven 包装脚本：

```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

也可以使用 Docker 构建后端：

```powershell
docker build -t fate-platform-backend ./backend
```

启动前端：

```powershell
cd frontend
npm install
npm run dev
```

访问地址：

```text
前端：http://localhost:5173
后端：http://localhost:8080
Knife4j/OpenAPI：http://localhost:8080/doc.html
```

## Docker Compose

```powershell
cd deploy
docker compose up -d --build
```

Compose 默认启动 MySQL、后端和前端。FATE Standalone 需要结合本机实际镜像和版本单独配置，平台已预留 `FATE_MODE=MOCK|FATE_PIPELINE|FATE_FLOW_API`。

## 实现说明

第一版默认使用 `MOCK` 执行器完成闭环：PSI 任务生成交集样本量，联邦任务生成模型评估指标并写入 `model_report`。真实 FATE 接入通过 `backend/fate-scripts/` 和 `/api/fate/jobs` 预留扩展点。

平台数据库只保存数据资产元信息、任务配置、运行结果和审计日志，不保存银行与运营商原始业务明文样本。
