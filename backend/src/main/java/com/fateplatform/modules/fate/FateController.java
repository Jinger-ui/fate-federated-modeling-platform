package com.fateplatform.modules.fate;

import com.fateplatform.common.ApiResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/fate/jobs")
public class FateController {
    private final JdbcTemplate jdbcTemplate;
    private final String fateMode;
    private final String fateFlowUrl;

    public FateController(JdbcTemplate jdbcTemplate,
                          @Value("${fate.mode}") String fateMode,
                          @Value("${fate.flow-url}") String fateFlowUrl) {
        this.jdbcTemplate = jdbcTemplate;
        this.fateMode = fateMode;
        this.fateFlowUrl = fateFlowUrl;
    }

    @PostMapping("/submit")
    public ApiResponse<Map<String, Object>> submit(@RequestBody Map<String, Object> body) {
        return ApiResponse.ok(Map.of(
                "mode", fateMode,
                "flowUrl", fateFlowUrl,
                "status", "MOCK".equalsIgnoreCase(fateMode) ? "READY" : "NOT_CONNECTED",
                "message", "FATE Adapter 已预留。真实执行需配置 FATE Flow 或 Pipeline 环境。"
        ));
    }

    @GetMapping("/{taskId}/status")
    public ApiResponse<Map<String, Object>> status(@PathVariable Long taskId) {
        Map<String, Object> task = jdbcTemplate.queryForMap("select id, status, external_job_id, error_msg from federated_task where id=?", taskId);
        task.put("fateMode", fateMode);
        return ApiResponse.ok(task);
    }

    @GetMapping("/{taskId}/logs")
    public ApiResponse<Object> logs(@PathVariable Long taskId) {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from task_runtime_log where task_id=? order by id desc", taskId));
    }

    @GetMapping("/engine/components")
    public ApiResponse<Object> engineComponents() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from fate_engine_component
                where enabled_flag=1 order by sort_no, id
                """));
    }

    @GetMapping("/algorithms")
    public ApiResponse<Object> algorithms(@RequestParam(required = false) String category,
                                          @RequestParam(required = false) String federatedType) {
        StringBuilder sql = new StringBuilder("""
                select * from federated_algorithm_template
                where enabled_flag=1
                """);
        List<Object> args = new ArrayList<>();
        if (category != null && !category.isBlank()) {
            sql.append(" and algorithm_category=?");
            args.add(category);
        }
        if (federatedType != null && !federatedType.isBlank()) {
            sql.append(" and federated_type=?");
            args.add(federatedType);
        }
        sql.append(" order by sort_no, id");
        return ApiResponse.ok(jdbcTemplate.queryForList(sql.toString(), args.toArray()));
    }

    @GetMapping("/algorithm-layers")
    public ApiResponse<Object> algorithmLayers() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from algorithm_experiment_layer
                where enabled_flag=1 order by layer_level, id
                """));
    }

    @GetMapping("/feature-steps")
    public ApiResponse<Object> featureSteps() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from feature_engineering_step
                where enabled_flag=1 order by step_order, id
                """));
    }

    @GetMapping("/risk-thresholds")
    public ApiResponse<Object> riskThresholds() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from risk_threshold_strategy
                where enabled_flag=1 order by min_probability, id
                """));
    }

    @GetMapping("/experiment-designs")
    public ApiResponse<Object> experimentDesigns() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from experiment_design_template
                where enabled_flag=1 order by sort_no, id
                """));
    }

    @GetMapping("/feature-groups")
    public ApiResponse<Object> featureGroups(@RequestParam(required = false) Long datasetId) {
        if (datasetId == null) {
            return ApiResponse.ok(jdbcTemplate.queryForList("""
                    select * from feature_group
                    where enabled_flag=1 order by sort_no, id
                    """));
        }
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from feature_group
                where enabled_flag=1 and dataset_id=? order by sort_no, id
                """, datasetId));
    }

    @GetMapping("/algorithm-templates")
    public ApiResponse<Object> algorithmTemplates() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select algorithm_code, algorithm_name, federated_type, task_target as task_type, need_psi,
                       true as need_label_owner, true as support_multi_host, default_params,
                       metrics as default_metrics,
                       case when enabled_flag=1 then 'ENABLED' else 'DISABLED' end as status
                from federated_algorithm_template
                order by sort_no, id
                """));
    }

    @GetMapping("/scenario-template-v2")
    public ApiResponse<Object> scenarioTemplateV2() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select scenario_code, scenario_name,
                       case when scenario_code like '%FRAUD%' then '金融安全'
                            when scenario_code like '%CHURN%' then '运营商'
                            when scenario_code like '%MARKETING%' then '精准营销'
                            else '金融风控' end as industry,
                       case when scenario_code like '%REGRESSION%' then 'REGRESSION' else 'BINARY_CLASSIFICATION' end as task_type,
                       label_owner as label_definition,
                       recommended_algorithms as recommended_algorithm,
                       recommended_metrics,
                       business_goal as description,
                       case when enabled_flag=1 then 'ENABLED' else 'DISABLED' end as status
                from business_scenario_template
                order by sort_no, id
                """));
    }

    @GetMapping("/scenario-templates")
    public ApiResponse<Object> scenarioTemplates() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from business_scenario_template
                where enabled_flag=1 order by sort_no, id
                """));
    }

    @GetMapping("/recommend-rules")
    public ApiResponse<Object> recommendRules() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select * from algorithm_recommend_rule
                where enabled_flag=1 order by priority desc, id
                """));
    }

    @PostMapping("/recommend")
    public ApiResponse<Map<String, Object>> recommend(@RequestBody Map<String, Object> body) {
        String dataDistribution = String.valueOf(body.getOrDefault("dataDistribution", "VERTICAL"));
        String taskTarget = String.valueOf(body.getOrDefault("taskTarget", "BINARY_CLASSIFICATION"));
        boolean nonlinear = Boolean.parseBoolean(String.valueOf(body.getOrDefault("nonlinear", false)));
        boolean explainability = Boolean.parseBoolean(String.valueOf(body.getOrDefault("explainability", false)));
        boolean lowOverlap = Boolean.parseBoolean(String.valueOf(body.getOrDefault("lowOverlap", false)));

        List<String> candidates = new ArrayList<>();
        List<String> reasons = new ArrayList<>();
        if ("HORIZONTAL".equalsIgnoreCase(dataDistribution)) {
            candidates.add("HOMO_LR");
            candidates.add("HOMO_SECUREBOOST");
            reasons.add("多方字段结构一致但样本不同，推荐横向联邦算法。");
        } else if ("REGRESSION".equalsIgnoreCase(taskTarget)) {
            candidates.add("HETERO_LINEAR_REGRESSION");
            candidates.add("SECUREBOOST_REGRESSION");
            reasons.add("任务目标为连续值，推荐联邦回归算法。");
        } else if ("COUNT_REGRESSION".equalsIgnoreCase(taskTarget)) {
            candidates.add("POISSON_REGRESSION");
            candidates.add("SECUREBOOST_REGRESSION");
            reasons.add("任务目标为次数预测，推荐 Poisson 或树模型回归。");
        } else {
            candidates.add("HETERO_LR");
            candidates.add("HETERO_SECUREBOOST");
            reasons.add("多方拥有相同用户但不同特征，推荐纵向联邦分类算法。");
        }
        if (nonlinear && !candidates.contains("HETERO_SECUREBOOST")) {
            candidates.add(0, "HETERO_SECUREBOOST");
        }
        if (nonlinear) {
            reasons.add("特征非线性或交互复杂，优先考虑 Hetero SecureBoost。");
        }
        if (explainability && !candidates.contains("HETERO_LR")) {
            candidates.add(0, "HETERO_LR");
        }
        if (explainability) {
            reasons.add("业务需要较强可解释性，建议保留 Hetero Logistic Regression 作为基线。");
        }
        if (lowOverlap) {
            candidates.add("FEDERATED_TRANSFER_LEARNING");
            reasons.add("样本重叠较少，联邦迁移学习可作为扩展方向。");
        }

        String placeholders = String.join(",", candidates.stream().map(x -> "?").toList());
        List<Map<String, Object>> algorithms = jdbcTemplate.queryForList("""
                select * from federated_algorithm_template
                where algorithm_code in (
                """ + placeholders + ") order by sort_no, id", candidates.toArray());
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("recommendedCodes", candidates);
        result.put("recommendedAlgorithms", algorithms);
        result.put("reasons", reasons);
        result.put("needPsi", "VERTICAL".equalsIgnoreCase(dataDistribution));
        return ApiResponse.ok(result);
    }
}
