package com.fateplatform.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(JdbcTemplate jdbcTemplate, PasswordEncoder passwordEncoder) {
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        Integer count = jdbcTemplate.queryForObject("select count(*) from sys_user where username='admin'", Integer.class);
        if (count != null && count == 0) {
            jdbcTemplate.update("""
                    insert into sys_user(username, password, real_name, org_id, status)
                    values (?, ?, ?, ?, 1)
                    """, "admin", passwordEncoder.encode("123456"), "系统管理员", 1L);
            Long userId = jdbcTemplate.queryForObject("select id from sys_user where username='admin'", Long.class);
            jdbcTemplate.update("insert ignore into sys_user_role(user_id, role_id) values (?, 1)", userId);
        }
    }
}
