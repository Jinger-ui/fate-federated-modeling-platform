package com.fateplatform.modules.org;

import com.fateplatform.common.ApiResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orgs")
public class OrgController {
    private final JdbcTemplate jdbcTemplate;

    public OrgController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(jdbcTemplate.queryForList("select * from org_info order by id"));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable Long id) {
        Map<String, Object> org = jdbcTemplate.queryForMap("select * from org_info where id=?", id);
        org.put("nodeConfig", jdbcTemplate.queryForList("select * from org_node_config where org_id=?", id));
        return ApiResponse.ok(org);
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@RequestBody Map<String, Object> body) {
        jdbcTemplate.update("""
                insert into org_info(org_code, org_name, org_type, party_id, contact_person, contact_phone, status, remark)
                values (?, ?, ?, ?, ?, ?, 1, ?)
                """, body.get("orgCode"), body.get("orgName"), body.get("orgType"), body.get("partyId"),
                body.get("contactPerson"), body.get("contactPhone"), body.get("remark"));
        Long id = jdbcTemplate.queryForObject("select id from org_info where org_code=?", Long.class, body.get("orgCode"));
        return ApiResponse.ok(Map.of("id", id));
    }

    @PutMapping("/{id}")
    public ApiResponse<Void> update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        jdbcTemplate.update("""
                update org_info set org_name=?, org_type=?, party_id=?, contact_person=?, contact_phone=?, remark=? where id=?
                """, body.get("orgName"), body.get("orgType"), body.get("partyId"), body.get("contactPerson"),
                body.get("contactPhone"), body.get("remark"), id);
        return ApiResponse.ok(null);
    }
}
