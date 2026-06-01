package com.fateplatform.modules.dashboard;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.modules.PlatformService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {
    private final PlatformService platformService;
    private final JdbcTemplate jdbcTemplate;

    public DashboardController(PlatformService platformService, JdbcTemplate jdbcTemplate) {
        this.platformService = platformService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/overview")
    public ApiResponse<Map<String, Object>> overview() {
        return ApiResponse.ok(platformService.dashboard());
    }

    @GetMapping("/task-trend")
    public ApiResponse<List<Map<String, Object>>> trend() {
        return ApiResponse.ok(jdbcTemplate.queryForList("""
                select date(created_at) as day, count(*) as count from federated_task group by date(created_at) order by day
                """));
    }

    @GetMapping("/model-compare")
    public ApiResponse<List<Map<String, Object>>> modelCompare() {
        return ApiResponse.ok((List<Map<String, Object>>) platformService.dashboard().get("modelCompare"));
    }

    @GetMapping("/recent-activities")
    public ApiResponse<List<Map<String, Object>>> activities() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from audit_log order by id desc limit 10"));
    }
}
