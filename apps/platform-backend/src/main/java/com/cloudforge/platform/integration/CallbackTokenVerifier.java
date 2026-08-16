package com.cloudforge.platform.integration;

import com.cloudforge.platform.common.InvalidCallbackTokenException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@Component
public class CallbackTokenVerifier {

    private final CallbackProperties properties;

    public CallbackTokenVerifier(
        CallbackProperties properties
    ) {
        this.properties = properties;
    }

    public void verify(String providedToken) {

        if (
            !StringUtils.hasText(properties.token())
            || !StringUtils.hasText(providedToken)
        ) {
            throw new InvalidCallbackTokenException();
        }

        byte[] expected = properties
            .token()
            .getBytes(StandardCharsets.UTF_8);

        byte[] provided = providedToken
            .getBytes(StandardCharsets.UTF_8);

        if (!MessageDigest.isEqual(expected, provided)) {
            throw new InvalidCallbackTokenException();
        }
    }
}
