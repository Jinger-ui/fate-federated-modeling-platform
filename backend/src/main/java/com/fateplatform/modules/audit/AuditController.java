package com.fateplatform.modules.audit;

import com.fateplatform.common.ApiResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/audit")
public class AuditController {
    private final JdbcTemplate jdbcTemplate;

    public AuditController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/logs")
    public ApiResponse<List<Map<String, Object>>> logs() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from audit_log order by id desc limit 200"));
    }

    @GetMapping("/login-logs")
    public ApiResponse<List<Map<String, Object>>> loginLogs() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from login_log order by id desc limit 200"));
    }
}
