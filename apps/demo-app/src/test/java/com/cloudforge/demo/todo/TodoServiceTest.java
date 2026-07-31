package com.cloudforge.demo.todo;

import com.cloudforge.demo.metrics.TodoMetrics;
import com.cloudforge.demo.todo.api.CreateTodoRequest;
import com.cloudforge.demo.todo.api.TodoResponse;
import com.cloudforge.demo.todo.api.UpdateTodoRequest;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class TodoServiceTest {

    private final TodoRepository repository = mock(TodoRepository.class);
    private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();
    private final TodoMetrics metrics = new TodoMetrics(meterRegistry);
    private final TodoService service = new TodoService(repository, metrics);

    @Test
    void shouldCreatePendingTodoAndIncrementMetric() {
        when(repository.save(any(Todo.class))).thenAnswer(invocation -> invocation.getArgument(0));

        TodoResponse response = service.create(
                new CreateTodoRequest("  AWS altyapısını kur  ", "  Terraform modülleri  ")
        );

        ArgumentCaptor<Todo> captor = ArgumentCaptor.forClass(Todo.class);
        verify(repository).save(captor.capture());

        Todo saved = captor.getValue();
        assertThat(saved.getTitle()).isEqualTo("AWS altyapısını kur");
        assertThat(saved.getDescription()).isEqualTo("Terraform modülleri");
        assertThat(saved.getStatus()).isEqualTo(TodoStatus.PENDING);
        assertThat(response.title()).isEqualTo("AWS altyapısını kur");
        assertThat(counterValue("create")).isEqualTo(1.0);
    }

    @Test
    void shouldIncrementUpdateAndCompleteMetrics() {
        UUID id = UUID.randomUUID();
        Todo todo = new Todo("Monitoring ekle", "Prometheus", TodoStatus.IN_PROGRESS);
        when(repository.findById(id)).thenReturn(Optional.of(todo));

        TodoResponse response = service.update(
                id,
                new UpdateTodoRequest("Monitoring ekle", "Prometheus", TodoStatus.COMPLETED)
        );

        assertThat(response.status()).isEqualTo(TodoStatus.COMPLETED);
        assertThat(counterValue("update")).isEqualTo(1.0);
        assertThat(counterValue("complete")).isEqualTo(1.0);
    }

    @Test
    void shouldThrowWhenTodoDoesNotExist() {
        UUID id = UUID.randomUUID();
        when(repository.findById(id)).thenReturn(Optional.empty());

        org.assertj.core.api.Assertions.assertThatThrownBy(() -> service.findById(id))
                .isInstanceOf(TodoNotFoundException.class)
                .hasMessageContaining(id.toString());
    }

    private double counterValue(String operation) {
        return meterRegistry.get("cloudforge.todo.operations")
                .tag("operation", operation)
                .counter()
                .count();
    }
}
