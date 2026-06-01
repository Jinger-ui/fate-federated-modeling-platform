package com.fateplatform.security;

import cn.hutool.json.JSONUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class JwtService {
    private final String secret;
    private final long ttlSeconds;

    public JwtService(@Value("${app.jwt-secret}") String secret,
                      @Value("${app.jwt-ttl-seconds}") long ttlSeconds) {
        this.secret = secret;
        this.ttlSeconds = ttlSeconds;
    }

    public String createToken(Map<String, Object> claims) {
        Map<String, Object> header = Map.of("alg", "HS256", "typ", "JWT");
        Map<String, Object> payload = new LinkedHashMap<>(claims);
        payload.put("exp", Instant.now().getEpochSecond() + ttlSeconds);
        String headerPart = base64Url(JSONUtil.toJsonStr(header).getBytes(StandardCharsets.UTF_8));
        String payloadPart = base64Url(JSONUtil.toJsonStr(payload).getBytes(StandardCharsets.UTF_8));
        String signature = sign(headerPart + "." + payloadPart);
        return headerPart + "." + payloadPart + "." + signature;
    }

    public Map<String, Object> parse(String token) {
        String[] parts = token.split("\\.");
        if (parts.length != 3 || !sign(parts[0] + "." + parts[1]).equals(parts[2])) {
            throw new IllegalArgumentException("Token 无效");
        }
        String json = new String(Base64.getUrlDecoder().decode(parts[1]), StandardCharsets.UTF_8);
        Map<String, Object> payload = JSONUtil.parseObj(json);
        long exp = Long.parseLong(String.valueOf(payload.get("exp")));
        if (Instant.now().getEpochSecond() > exp) {
            throw new IllegalArgumentException("Token 已过期");
        }
        return payload;
    }

    private String sign(String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return base64Url(mac.doFinal(data.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) {
            throw new IllegalStateException("JWT 签名失败", ex);
        }
    }

    private String base64Url(byte[] bytes) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
