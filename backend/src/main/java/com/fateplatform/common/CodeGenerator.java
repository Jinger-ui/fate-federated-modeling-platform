package com.fateplatform.common;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

public final class CodeGenerator {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private CodeGenerator() {
    }

    public static String next(String prefix) {
        return prefix + LocalDateTime.now().format(FORMATTER) + ThreadLocalRandom.current().nextInt(100, 999);
    }
}
