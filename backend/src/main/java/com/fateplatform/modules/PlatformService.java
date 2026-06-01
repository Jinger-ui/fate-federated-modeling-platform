package com.fateplatform.modules;

import cn.hutool.json.JSONUtil;
import com.fateplatform.common.CodeGenerator;
import com.fateplatform.common.CurrentUser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class PlatformService {
    private final JdbcTemplate jdbcTemplate;
    private final String fateMode;
    private final String pipelinePython;
    private final String scriptsDir;

    public PlatformService(JdbcTemplate jdbcTemplate,
                           @Value("${fate.mode}") String fateMode,
                           @Value("${fate.pipeline-python}") String pipelinePython,
                           @Value("${fate.scripts-dir}") String scriptsDir) {
        this.jdbcTemplate = jdbcTemplate;
        this.fateMode = fateMode;
        this.pipelinePython = pipelinePython;
        this.scriptsDir = scriptsDir;
    }

    public List<Map<String, Object>> list(String table, String orderBy) {
        return jdbcTemplate.queryForList("select * from " + table + " " + orderBy);
    }

    public List<Map<String, Object>> listAssets() {
        if (CurrentUser.admin()) {
            return jdbcTemplate.queryForList("""
                    select a.*, o.org_name from data_asset a left join org_info o on a.org_id=o.id order by a.id desc
                    """);
        }
        return jdbcTemplate.queryForList("""
                select a.*, o.org_name from data_asset a left join org_info o on a.org_id=o.id
                where a.org_id=? order by a.id desc
                """, CurrentUser.orgId());
    }

    public Map<String, Object> assetDetail(Long id) {
        Map<String, Object> asset = jdbcTemplate.queryForMap("select * from data_asset where id=?", id);
        asset.put("fields", jdbcTemplate.queryForList("select * from data_asset_field where asset_id=? order by id", id));
        return asset;
    }

    @Transactional
    public Long createAsset(Map<String, Object> body) {
        jdbcTemplate.update("""
                insert into data_asset(asset_code, asset_name, org_id, asset_type, source_type, source_ref, id_field,
                label_field, sample_count, status, version_no, created_by)
                values (?, ?, ?, ?, ?, ?, ?, ?, ?, 'VALID', ?, ?)
                """,
                body.get("assetCode"), body.get("assetName"), body.get("orgId"), body.getOrDefault("assetType", "TRAIN"),
                body.getOrDefault("sourceType", "FATE_TABLE"), body.get("sourceRef"), body.getOrDefault("idField", "user_id"),
                body.get("labelField"), body.getOrDefault("sampleCount", 0), body.getOrDefault("versionNo", "v1"), CurrentUser.userId());
        Long id = jdbcTemplate.queryForObject("select last_insert_id()", Long.class);
        List<Map<String, Object>> fields = (List<Map<String, Object>>) body.get("fields");
        if (fields != null) {
            for (Map<String, Object> field : fields) {
                jdbcTemplate.update("""
                        insert into data_asset_field(asset_id, field_name, field_type, field_role, nullable_flag, description)
                        values (?, ?, ?, ?, ?, ?)
                        """, id, field.get("fieldName"), field.getOrDefault("fieldType", "string"),
                        field.getOrDefault("fieldRole", "FEATURE"), field.getOrDefault("nullableFlag", 1),
                        field.getOrDefault("description", ""));
            }
        }
        return id;
    }

    @Transactional
    public Map<String, Object> createPsi(Map<String, Object> body) {
        String code = CodeGenerator.next("PSI");
        jdbcTemplate.update("""
                insert into psi_task(task_code, task_name, guest_org_id, host_org_id, guest_asset_id, host_asset_id,
                status, run_mode, id_field, submit_time)
                values (?, ?, ?, ?, ?, ?, 'RUNNING', ?, ?, now())
                """, code, body.get("taskName"), body.get("guestOrgId"), body.get("hostOrgId"), body.get("guestAssetId"),
                body.get("hostAssetId"), body.getOrDefault("runMode", "MOCK"), body.getOrDefault("idField", "user_id"));
        Long id = jdbcTemplate.queryForObject("select last_insert_id()", Long.class);
        int intersect = ThreadLocalRandom.current().nextInt(3600, 4900);
        jdbcTemplate.update("""
                update psi_task set status='SUCCESS', finish_time=now(), result_ref=?, intersect_count=? where id=?
                """, "mock://psi/intersection/" + code, intersect, id);
        runtimeLog(id, "INFO", "PSI MOCK 执行完成，交集样本量 " + intersect);
        return Map.of("taskId", id, "taskCode", code, "status", "SUCCESS", "intersectCount", intersect);
    }

    @Transactional
    public Map<String, Object> createFederatedTask(Map<String, Object> body) {
        String code = CodeGenerator.next("FT");
        jdbcTemplate.update("""
                insert into federated_task(task_code, task_name, task_mode, algorithm_type, psi_task_id, status,
                submit_type, created_by)
                values (?, ?, ?, ?, ?, 'DRAFT', ?, ?)
                """, code, body.get("taskName"), body.getOrDefault("taskMode", "FEDERATED"),
                body.getOrDefault("algorithmType", "HETERO_LR"), body.get("psiTaskId"),
                body.getOrDefault("submitType", fateMode), CurrentUser.userId());
        Long id = jdbcTemplate.queryForObject("select last_insert_id()", Long.class);
        List<Map<String, Object>> parties = (List<Map<String, Object>>) body.get("parties");
        if (parties != null) {
            for (Map<String, Object> party : parties) {
                jdbcTemplate.update("""
                        insert into federated_task_party(task_id, org_id, role_type, asset_id, party_id, has_label)
                        values (?, ?, ?, ?, ?, ?)
                        """, id, party.get("orgId"), party.get("roleType"), party.get("assetId"), party.get("partyId"),
                        party.getOrDefault("hasLabel", 0));
            }
        }
        jdbcTemplate.update("insert into federated_task_param(task_id, param_type, param_json) values (?, 'ALGO', ?)",
                id, JSONUtil.toJsonStr(body.getOrDefault("algoParams", Map.of("maxIter", 30, "learningRate", 0.05))));
        return Map.of("taskId", id, "taskCode", code, "status", "DRAFT");
    }

    @Transactional
    public Map<String, Object> submitFederatedTask(Long taskId) {
        Map<String, Object> task = jdbcTemplate.queryForMap("select * from federated_task where id=?", taskId);
        String submitType = String.valueOf(task.get("submit_type"));
        String externalJobId = "MOCK-JOB-" + task.get("task_code");
        jdbcTemplate.update("update federated_task set status='RUNNING', submit_time=now(), external_job_id=? where id=?",
                externalJobId, taskId);
        runtimeLog(taskId, "INFO", "任务提交成功，执行模式：" + submitType);
        if ("MOCK".equalsIgnoreCase(submitType)) {
            completeMockTraining(taskId);
        } else if ("FATE_PIPELINE".equalsIgnoreCase(submitType) || "PIPELINE".equalsIgnoreCase(submitType)) {
            runFatePipeline(taskId);
        } else {
            externalJobId = submitType + "-PENDING-" + task.get("task_code");
            jdbcTemplate.update("""
                    update federated_task set status='FAILED', finish_time=now(), external_job_id=?, error_msg=? where id=?
                    """, externalJobId, "当前环境未检测到可用 FATE 服务，请切换 MOCK 或配置 FATE Flow/Pipeline。", taskId);
            runtimeLog(taskId, "ERROR", "FATE 接入失败：未配置可用运行环境");
        }
        return jdbcTemplate.queryForMap("select * from federated_task where id=?", taskId);
    }

    public Map<String, Object> report(Long taskId) {
        List<Map<String, Object>> reports = jdbcTemplate.queryForList("select * from model_report where task_id=? order by id desc", taskId);
        return reports.isEmpty() ? Map.of() : reports.get(0);
    }

    public List<Map<String, Object>> curves(Long taskId) {
        return jdbcTemplate.queryForList("""
                select c.* from model_curve_data c join model_report r on c.report_id=r.id where r.task_id=?
                """, taskId);
    }

    public Map<String, Object> dashboard() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orgCount", jdbcTemplate.queryForObject("select count(*) from org_info", Integer.class));
        data.put("assetCount", jdbcTemplate.queryForObject("select count(*) from data_asset", Integer.class));
        data.put("taskCount", jdbcTemplate.queryForObject("select count(*) from federated_task", Integer.class));
        data.put("runningTaskCount", jdbcTemplate.queryForObject("select count(*) from federated_task where status='RUNNING'", Integer.class));
        data.put("successRate", jdbcTemplate.queryForObject("""
                select ifnull(round(sum(case when status='SUCCESS' then 1 else 0 end) * 1.0 / nullif(count(*), 0), 4), 0)
                from federated_task
                """, BigDecimal.class));
        data.put("recentTasks", jdbcTemplate.queryForList("select * from federated_task order by id desc limit 6"));
        data.put("modelCompare", jdbcTemplate.queryForList("""
                select t.task_name, t.task_mode, t.algorithm_type, r.auc, r.ks, r.f1_score
                from model_report r join federated_task t on r.task_id=t.id order by r.id desc limit 6
                """));
        return data;
    }

    public void runtimeLog(Long taskId, String level, String content) {
        String safeContent = content == null ? "" : content;
        if (safeContent.length() > 1800) {
            safeContent = safeContent.substring(0, 1800) + "...[truncated]";
        }
        jdbcTemplate.update("insert into task_runtime_log(task_id, log_level, log_time, content) values (?, ?, ?, ?)",
                taskId, level, LocalDateTime.now(), safeContent);
    }

    private void completeMockTraining(Long taskId) {
        double base = 0.82 + ThreadLocalRandom.current().nextDouble(0.08);
        double auc = base + 0.04;
        double ks = 0.47 + ThreadLocalRandom.current().nextDouble(0.08);
        double loss = 0.42 - ThreadLocalRandom.current().nextDouble(0.12);
        jdbcTemplate.update("update federated_task set status='SUCCESS', finish_time=now() where id=?", taskId);
        jdbcTemplate.update("""
                insert into model_report(task_id, report_name, dataset_type, accuracy, precision_rate, recall_rate,
                f1_score, auc, ks, loss, summary_text)
                values (?, '联邦建模评估报告', 'TEST', ?, ?, ?, ?, ?, ?, ?, ?)
                """, taskId, round(base), round(base - 0.03), round(base - 0.05), round(base - 0.04),
                round(auc), round(ks), round(loss), "MOCK 模式生成的演示指标，原始数据未进入平台数据库。");
        Long reportId = jdbcTemplate.queryForObject("select last_insert_id()", Long.class);
        jdbcTemplate.update("insert into model_curve_data(report_id, curve_type, curve_json) values (?, 'ROC', ?)",
                reportId, "[{\"x\":0,\"y\":0},{\"x\":0.1,\"y\":0.42},{\"x\":0.3,\"y\":0.72},{\"x\":1,\"y\":1}]");
        jdbcTemplate.update("insert into model_curve_data(report_id, curve_type, curve_json) values (?, 'LOSS', ?)",
                reportId, "[{\"x\":1,\"y\":0.68},{\"x\":10,\"y\":0.43},{\"x\":20,\"y\":0.35},{\"x\":30,\"y\":0.30}]");
        runtimeLog(taskId, "INFO", "MOCK 联邦训练完成，评估报告已生成");
    }

    private void runFatePipeline(Long taskId) {
        try {
            Map<String, Object> task = jdbcTemplate.queryForMap("select * from federated_task where id=?", taskId);
            List<Map<String, Object>> parties = jdbcTemplate.queryForList("""
                    select p.*, a.source_ref from federated_task_party p
                    join data_asset a on p.asset_id=a.id where p.task_id=?
                    """, taskId);
            Map<String, Object> guest = parties.stream()
                    .filter(p -> "GUEST".equalsIgnoreCase(String.valueOf(p.get("role_type"))))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("FATE Pipeline 需要 GUEST 参与方"));
            Map<String, Object> host = parties.stream()
                    .filter(p -> "HOST".equalsIgnoreCase(String.valueOf(p.get("role_type"))))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("FATE Pipeline 需要 HOST 参与方"));

            Map<String, String> guestTable = splitFateTable(String.valueOf(guest.get("source_ref")));
            Map<String, String> hostTable = splitFateTable(String.valueOf(host.get("source_ref")));
            String algorithm = String.valueOf(task.get("algorithm_type"));
            String script = algorithm.contains("SECUREBOOST")
                    ? scriptsDir + "/hetero_secureboost_pipeline_template.py"
                    : scriptsDir + "/hetero_lr_pipeline_template.py";

            List<String> command = new ArrayList<>();
            command.add(pipelinePython);
            command.add(script);
            command.add("--guest-party-id");
            command.add(String.valueOf(guest.get("party_id")));
            command.add("--host-party-id");
            command.add(String.valueOf(host.get("party_id")));
            command.add("--arbiter-party-id");
            command.add(String.valueOf(host.get("party_id")));
            command.add("--guest-namespace");
            command.add(guestTable.get("namespace"));
            command.add("--guest-table");
            command.add(guestTable.get("table"));
            command.add("--host-namespace");
            command.add(hostTable.get("namespace"));
            command.add("--host-table");
            command.add(hostTable.get("table"));

            runtimeLog(taskId, "INFO", "开始执行 FATE Pipeline：" + String.join(" ", command));
            Process process = new ProcessBuilder(command).redirectErrorStream(true).start();
            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append(System.lineSeparator());
                    runtimeLog(taskId, "INFO", line);
                }
            }
            int exitCode = process.waitFor();
            if (exitCode == 0) {
                String jobId = extractJobId(output.toString(), "FATE-PIPELINE-" + task.get("task_code"));
                jdbcTemplate.update("update federated_task set status='SUCCESS', finish_time=now(), external_job_id=? where id=?",
                        jobId, taskId);
                jdbcTemplate.update("""
                        insert into model_report(task_id, report_name, dataset_type, summary_text)
                        values (?, 'FATE Pipeline 训练报告', 'TEST', ?)
                        """, taskId, "FATE Pipeline 已执行完成。指标可继续通过 FATE Flow API 同步解析。");
                runtimeLog(taskId, "INFO", "FATE Pipeline 执行完成，jobId=" + jobId);
            } else {
                jdbcTemplate.update("update federated_task set status='FAILED', finish_time=now(), error_msg=? where id=?",
                        "FATE Pipeline 进程退出码：" + exitCode, taskId);
                runtimeLog(taskId, "ERROR", "FATE Pipeline 执行失败，退出码 " + exitCode);
            }
        } catch (Exception ex) {
            jdbcTemplate.update("update federated_task set status='FAILED', finish_time=now(), error_msg=? where id=?",
                    ex.getMessage(), taskId);
            runtimeLog(taskId, "ERROR", "FATE Pipeline 调用异常：" + ex.getMessage());
        }
    }

    private Map<String, String> splitFateTable(String sourceRef) {
        int index = sourceRef.lastIndexOf('.');
        if (index <= 0 || index == sourceRef.length() - 1) {
            throw new IllegalArgumentException("FATE_TABLE source_ref 需要使用 namespace.table 格式：" + sourceRef);
        }
        return Map.of("namespace", sourceRef.substring(0, index), "table", sourceRef.substring(index + 1));
    }

    private String extractJobId(String output, Object fallback) {
        for (String line : output.split("\\R")) {
            if (line.startsWith("FATE_JOB_ID=")) {
                return line.substring("FATE_JOB_ID=".length()).trim();
            }
        }
        return String.valueOf(fallback);
    }

    private BigDecimal round(double value) {
        return BigDecimal.valueOf(value).setScale(4, java.math.RoundingMode.HALF_UP);
    }
}
