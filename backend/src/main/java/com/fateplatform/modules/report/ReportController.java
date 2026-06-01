package com.fateplatform.modules.report;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.modules.PlatformService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reports")
public class ReportController {
    private final PlatformService platformService;
    private final JdbcTemplate jdbcTemplate;

    public ReportController(PlatformService platformService, JdbcTemplate jdbcTemplate) {
        this.platformService = platformService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select r.*, t.task_name, t.task_mode, t.algorithm_type
                from model_report r join federated_task t on r.task_id=t.id order by r.id desc
                """));
    }

    @GetMapping("/{taskId}/summary")
    public ApiResponse<Map<String, Object>> summary(@PathVariable Long taskId) {
        return ApiResponse.ok(platformService.report(taskId));
    }

    @GetMapping("/{taskId}/metrics")
    public ApiResponse<Map<String, Object>> metrics(@PathVariable Long taskId) {
        return ApiResponse.ok(platformService.report(taskId));
    }

    @GetMapping("/{taskId}/curves")
    public ApiResponse<List<Map<String, Object>>> curves(@PathVariable Long taskId) {
        return ApiResponse.ok(platformService.curves(taskId));
    }

    @GetMapping("/compare")
    public ApiResponse<List<Map<String, Object>>> compare() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select t.task_name, t.task_mode, t.algorithm_type, r.accuracy, r.precision_rate,
                r.recall_rate, r.f1_score, r.auc, r.ks, r.loss
                from model_report r join federated_task t on r.task_id=t.id order by r.id desc limit 10
                """));
    }
}
