package com.cloudforge.demo.todo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Import;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import static org.assertj.core.api.Assertions.assertThat;

@Testcontainers(disabledWithoutDocker = true)
@DataJpaTest
@Import(org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration.class)
class TodoRepositoryIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres =
            new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private TodoRepository repository;

    @Test
    void shouldPersistTodoInPostgreSql() {
        Todo todo = repository.save(
                new Todo("Pipeline testini yaz", "Testcontainers kullan", TodoStatus.IN_PROGRESS)
        );

        assertThat(repository.findById(todo.getId()))
                .isPresent()
                .get()
                .extracting(Todo::getStatus)
                .isEqualTo(TodoStatus.IN_PROGRESS);
    }
}
