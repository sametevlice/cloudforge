package com.cloudforge.demo.version;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class VersionControllerTest {

    @Test
    void shouldReturnConfiguredVersion() {
        VersionController controller = new VersionController("1.2.3", "a84f92d");

        var result = controller.getVersion();

        assertThat(result)
                .containsEntry("application", "cloudforge-demo-app")
                .containsEntry("version", "1.2.3")
                .containsEntry("commit", "a84f92d");
    }
}
