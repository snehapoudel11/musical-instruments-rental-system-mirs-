package com.mirs.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Tracks failed login attempts and applies a temporary in-memory lockout.
 */
public final class LoginSecurityService {

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final long LOCKOUT_DURATION_MS = 15L * 60L * 1000L;

    private static final Map<String, Integer> FAILED_ATTEMPTS = new ConcurrentHashMap<>();
    private static final Map<String, Long> LOCKED_UNTIL = new ConcurrentHashMap<>();

    private LoginSecurityService() {
    }

    public static boolean isLocked(String username) {
        String key = normalize(username);
        if (key.isEmpty()) {
            return false;
        }

        Long lockedUntil = LOCKED_UNTIL.get(key);
        if (lockedUntil == null) {
            return false;
        }

        if (lockedUntil <= System.currentTimeMillis()) {
            LOCKED_UNTIL.remove(key);
            FAILED_ATTEMPTS.remove(key);
            return false;
        }

        return true;
    }

    public static long getRemainingLockMinutes(String username) {
        String key = normalize(username);
        Long lockedUntil = LOCKED_UNTIL.get(key);
        if (lockedUntil == null) {
            return 0;
        }

        long remainingMs = lockedUntil - System.currentTimeMillis();
        if (remainingMs <= 0) {
            LOCKED_UNTIL.remove(key);
            FAILED_ATTEMPTS.remove(key);
            return 0;
        }

        return (remainingMs + 59999L) / 60000L;
    }

    public static void recordFailedAttempt(String username) {
        String key = normalize(username);
        if (key.isEmpty()) {
            return;
        }

        int attempts = FAILED_ATTEMPTS.getOrDefault(key, 0) + 1;
        if (attempts >= MAX_FAILED_ATTEMPTS) {
            LOCKED_UNTIL.put(key, System.currentTimeMillis() + LOCKOUT_DURATION_MS);
            FAILED_ATTEMPTS.remove(key);
            return;
        }

        FAILED_ATTEMPTS.put(key, attempts);
    }

    public static void clearFailedAttempts(String username) {
        String key = normalize(username);
        if (key.isEmpty()) {
            return;
        }

        FAILED_ATTEMPTS.remove(key);
        LOCKED_UNTIL.remove(key);
    }

    public static int getRemainingAttempts(String username) {
        String key = normalize(username);
        int attempts = FAILED_ATTEMPTS.getOrDefault(key, 0);
        int remaining = MAX_FAILED_ATTEMPTS - attempts;
        return Math.max(remaining, 0);
    }

    private static String normalize(String username) {
        return username == null ? "" : username.trim().toLowerCase();
    }
}
