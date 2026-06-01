package com.fateplatform.modules.psi;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.modules.PlatformService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/psi/tasks")
public class PsiController {
    private final PlatformService platformService;
    private final JdbcTemplate jdbcTemplate;

    public PsiController(PlatformService platformService, JdbcTemplate jdbcTemplate) {
        this.platformService = platformService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from psi_task order by id desc"));
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@RequestBody Map<String, Object> body) {
        return ApiResponse.ok(platformService.createPsi(body));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable Long id) {
        return ApiResponse.ok(jdbcTemplate.queryForMap("select * from psi_task where id=?", id));
    }

    @GetMapping("/{id}/result")
    public ApiResponse<Map<String, Object>> result(@PathVariable Long id) {
        Map<String, Object> psi = jdbcTemplate.queryForMap("select * from psi_task where id=?", id);
        return ApiResponse.ok(Map.of(
                "taskId", id,
                "status", psi.get("status"),
                "intersectCount", psi.get("intersect_count"),
                "resultRef", psi.get("result_ref"),
                "privacyNote", "平台仅保存交集数量和结果引用，不保存明文交集ID。"
        ));
    }
}
