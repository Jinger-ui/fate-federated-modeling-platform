package com.fateplatform.common;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class AuditFilter extends OncePerRequestFilter {
    private final JdbcTemplate jdbcTemplate;

    public AuditFilter(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !request.getRequestURI().startsWith("/api/") || request.getRequestURI().startsWith("/api/auth/login");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        long start = System.currentTimeMillis();
        try {
            chain.doFilter(request, response);
        } finally {
            if (!"GET".equalsIgnoreCase(request.getMethod()) || request.getRequestURI().contains("/submit")) {
                String module = request.getRequestURI().split("/").length > 2 ? request.getRequestURI().split("/")[2] : "api";
                jdbcTemplate.update("""
                        insert into audit_log(user_id, username, org_id, module_name, operation_type, request_uri,
                        request_method, response_code, success_flag, cost_ms, ip)
                        values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        """,
                        CurrentUser.userId(), CurrentUser.username(), CurrentUser.orgId(), module.toUpperCase(),
                        request.getMethod(), request.getRequestURI(), request.getMethod(), response.getStatus(),
                        response.getStatus() < 400 ? 1 : 0, System.currentTimeMillis() - start, request.getRemoteAddr());
            }
        }
    }
}
