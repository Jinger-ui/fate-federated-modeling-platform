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
        repairSeedText();
        ensureDemoTaskVolume();
    }

    private void repairSeedText() {
        jdbcTemplate.update("update sys_user set real_name=? where username='admin'", "系统管理员");
        jdbcTemplate.update("update sys_role set role_name=? where role_code='ADMIN'", "平台管理员");
        jdbcTemplate.update("update sys_role set role_name=? where role_code='ORG_USER'", "机构操作员");
        jdbcTemplate.update("update sys_role set role_name=? where role_code='AUDITOR'", "审计员");

        jdbcTemplate.update("""
                update org_info set org_name=?, contact_person=?, remark=?
                where id=1
                """, "示例银行机构", "银行负责人", "持有标签与金融特征");
        jdbcTemplate.update("""
                update org_info set org_name=?, contact_person=?, remark=?
                where id=2
                """, "示例运营商机构", "运营商负责人", "持有通信行为特征");
        jdbcTemplate.update("""
                update org_info set org_name=?, contact_person=?, remark=?
                where id=3
                """, "区域商业银行", "风控负责人", "用于扩展多银行联合建模演示");
        jdbcTemplate.update("""
                update org_info set org_name=?, contact_person=?, remark=?
                where id=4
                """, "虚拟运营商机构", "数据负责人", "用于扩展多运营商特征协作演示");
        jdbcTemplate.update("""
                update data_asset set asset_name=?
                where id=1
                """, "银行信用风险训练集V1");
        jdbcTemplate.update("""
                update data_asset set asset_name=?
                where id=2
                """, "运营商通信行为训练集V1");
        jdbcTemplate.update("update data_asset set asset_name=? where id=3", "银行信用风险测试集V1");
        jdbcTemplate.update("update data_asset set asset_name=? where id=4", "运营商通信行为测试集V1");
        jdbcTemplate.update("update data_asset set asset_name=? where id=5", "银行单方基线实验数据");
        jdbcTemplate.update("update data_asset set asset_name=? where id=6", "运营商单方基线实验数据");

        jdbcTemplate.update("""
                update psi_task set task_name=?
                where task_code='PSI202606010001' or task_code='PSI20260601104614904'
                """, "银行与运营商样本对齐");
        jdbcTemplate.update("update psi_task set task_name=? where task_code='PSI202606010002'", "银行与运营商测试样本对齐");
        jdbcTemplate.update("update psi_task set task_name=? where task_code='PSI202606010003'", "区域银行扩展样本对齐");
        jdbcTemplate.update("""
                update federated_task set task_name=?
                where task_name like '%?%' and submit_type='FATE_PIPELINE'
                """, "真实 FATE Pipeline 提交验证");
        jdbcTemplate.update("""
                update federated_task set task_name=?
                where task_name like '%?%' and submit_type='MOCK'
                """, "MOCK 联邦建模闭环验证");
        jdbcTemplate.update("""
                update model_report set report_name=?, summary_text=?
                where id in (3, 4)
                """, "联邦模型评估报告", "联邦模型融合银行与运营商特征，AUC 和 KS 均优于单方基线。");

        removeDuplicatedAssetFields();
        repairAssetFieldText();
    }

    private void repairAssetFieldText() {
        for (long assetId = 1; assetId <= 6; assetId++) {
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='user_id'", "用户唯一标识", assetId);
        }
        for (long assetId : new long[]{1, 3, 5}) {
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='age'", "年龄", assetId);
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='credit_score'", "信用评分", assetId);
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='loan_amount'", "贷款金额", assetId);
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='is_overdue'", "是否逾期", assetId);
        }
        for (long assetId : new long[]{2, 4, 6}) {
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='net_age_months'", "在网时长", assetId);
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='monthly_fee'", "月套餐消费", assetId);
            jdbcTemplate.update("update data_asset_field set description=? where asset_id=? and field_name='arrears_count'", "欠费次数", assetId);
        }
        jdbcTemplate.update("update data_asset_field set description=? where asset_id=6 and field_name='is_overdue_mock'", "模拟逾期标签");
    }

    private void ensureDemoTaskVolume() {
        jdbcTemplate.update("""
                insert ignore into audit_log(id, user_id, username, org_id, module_name, operation_type, request_uri,
                request_method, response_code, success_flag, cost_ms, ip, created_at)
                values (4, 1, 'admin', 1, 'DASHBOARD', 'GET', '/api/dashboard/overview', 'GET', '200', 1, 28, '127.0.0.1', '2026-06-01 10:10:00')
                """);
        jdbcTemplate.update("""
                insert ignore into audit_log(id, user_id, username, org_id, module_name, operation_type, request_uri,
                request_method, response_code, success_flag, cost_ms, ip, created_at)
                values (5, 1, 'admin', 1, 'ASSET', 'GET', '/api/data-assets', 'GET', '200', 1, 42, '127.0.0.1', '2026-06-01 10:12:00')
                """);
    }

    private void removeDuplicatedAssetFields() {
        jdbcTemplate.update("""
                delete from data_asset_field
                where id not in (
                    select min_id from (
                        select min(id) min_id
                        from data_asset_field
                        group by asset_id, field_name
                    ) t
                )
                """);
    }
}
