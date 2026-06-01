package com.fateplatform.common;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Map;

public final class CurrentUser {
    private CurrentUser() {
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Object> claims() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getDetails() instanceof Map<?, ?> details)) {
            return Map.of();
        }
        return (Map<String, Object>) details;
    }

    public static Long userId() {
        Object value = claims().get("userId");
        return value == null ? null : Long.parseLong(String.valueOf(value));
    }

    public static Long orgId() {
        Object value = claims().get("orgId");
        return value == null ? null : Long.parseLong(String.valueOf(value));
    }

    public static String username() {
        return String.valueOf(claims().getOrDefault("username", "anonymous"));
    }

    public static String role() {
        return String.valueOf(claims().getOrDefault("role", "ORG_USER"));
    }

    public static boolean admin() {
        return "ADMIN".equals(role());
    }
}
