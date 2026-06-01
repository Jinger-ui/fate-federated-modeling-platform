package com.fateplatform.modules.auth;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.common.CurrentUser;
import com.fateplatform.security.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthController(JdbcTemplate jdbcTemplate, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@Valid @RequestBody LoginRequest request, HttpServletRequest servletRequest) {
        List<Map<String, Object>> users = jdbcTemplate.queryForList("select * from sys_user where username=? and status=1", request.username());
        if (users.isEmpty() || !passwordEncoder.matches(request.password(), String.valueOf(users.get(0).get("password")))) {
            jdbcTemplate.update("insert into login_log(username, success_flag, failure_reason, ip, user_agent) values (?, 0, ?, ?, ?)",
                    request.username(), "用户名或密码错误", servletRequest.getRemoteAddr(), servletRequest.getHeader("User-Agent"));
            throw new IllegalArgumentException("用户名或密码错误");
        }
        Map<String, Object> user = users.get(0);
        String role = jdbcTemplate.queryForObject("""
                select r.role_code from sys_role r join sys_user_role ur on r.id=ur.role_id
                where ur.user_id=? order by r.id limit 1
                """, String.class, user.get("id"));
        Map<String, Object> claims = new LinkedHashMap<>();
        claims.put("userId", user.get("id"));
        claims.put("username", user.get("username"));
        claims.put("realName", user.get("real_name"));
        claims.put("orgId", user.get("org_id"));
        claims.put("role", role);
        jdbcTemplate.update("insert into login_log(username, success_flag, ip, user_agent) values (?, 1, ?, ?)",
                request.username(), servletRequest.getRemoteAddr(), servletRequest.getHeader("User-Agent"));
        return ApiResponse.ok(Map.of("token", jwtService.createToken(claims), "userInfo", claims));
    }

    @GetMapping("/me")
    public ApiResponse<Map<String, Object>> me() {
        return ApiResponse.ok(CurrentUser.claims());
    }

    @GetMapping("/menus")
    public ApiResponse<List<Map<String, Object>>> menus() {
        return ApiResponse.ok(List.of(
                Map.of("path", "/dashboard", "title", "首页看板", "icon", "DataBoard"),
                Map.of("path", "/orgs", "title", "机构管理", "icon", "OfficeBuilding"),
                Map.of("path", "/assets", "title", "数据资产", "icon", "Coin"),
                Map.of("path", "/psi", "title", "样本对齐", "icon", "Connection"),
                Map.of("path", "/tasks", "title", "联邦建模", "icon", "Cpu"),
                Map.of("path", "/reports", "title", "模型评估", "icon", "TrendCharts"),
                Map.of("path", "/audit", "title", "审计日志", "icon", "DocumentChecked")
        ));
    }

    public record LoginRequest(@NotBlank String username, @NotBlank String password) {
    }
}
