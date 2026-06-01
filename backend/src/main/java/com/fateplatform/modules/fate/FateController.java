package com.fateplatform.modules.fate;

import com.fateplatform.common.ApiResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

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
}
