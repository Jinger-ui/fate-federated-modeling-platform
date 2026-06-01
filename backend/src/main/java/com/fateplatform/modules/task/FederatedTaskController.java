package com.fateplatform.modules.task;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.modules.PlatformService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/federated/tasks")
public class FederatedTaskController {
    private final PlatformService platformService;
    private final JdbcTemplate jdbcTemplate;

    public FederatedTaskController(PlatformService platformService, JdbcTemplate jdbcTemplate) {
        this.platformService = platformService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from federated_task order by id desc"));
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@RequestBody Map<String, Object> body) {
        return ApiResponse.ok(platformService.createFederatedTask(body));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable Long id) {
        Map<String, Object> task = jdbcTemplate.queryForMap("select * from federated_task where id=?", id);
        task.put("parties", jdbcTemplate.queryForList("select * from federated_task_party where task_id=?", id));
        task.put("params", jdbcTemplate.queryForList("select * from federated_task_param where task_id=?", id));
        return ApiResponse.ok(task);
    }

    @PostMapping("/{id}/submit")
    public ApiResponse<Map<String, Object>> submit(@PathVariable Long id) {
        return ApiResponse.ok(platformService.submitFederatedTask(id));
    }

    @PostMapping("/{id}/retry")
    public ApiResponse<Map<String, Object>> retry(@PathVariable Long id) {
        return ApiResponse.ok(platformService.submitFederatedTask(id));
    }

    @GetMapping("/{id}/runtime")
    public ApiResponse<Map<String, Object>> runtime(@PathVariable Long id) {
        Map<String, Object> task = jdbcTemplate.queryForMap("select * from federated_task where id=?", id);
        task.put("logs", jdbcTemplate.queryForList("select * from task_runtime_log where task_id=? order by id desc limit 30", id));
        return ApiResponse.ok(task);
    }

    @GetMapping("/{id}/logs")
    public ApiResponse<List<Map<String, Object>>> logs(@PathVariable Long id) {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from task_runtime_log where task_id=? order by id desc", id));
    }
}
