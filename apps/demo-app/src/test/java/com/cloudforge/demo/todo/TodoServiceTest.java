package com.cloudforge.demo.todo;

import com.cloudforge.demo.todo.api.CreateTodoRequest;
import com.cloudforge.demo.todo.api.TodoResponse;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class TodoServiceTest {

    private final TodoRepository repository = mock(TodoRepository.class);
    private final TodoService service = new TodoService(repository);

    @Test
    void shouldCreatePendingTodo() {
        when(repository.save(org.mockito.ArgumentMatchers.any(Todo.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

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
    }

    @Test
    void shouldThrowWhenTodoDoesNotExist() {
        UUID id = UUID.randomUUID();
        when(repository.findById(id)).thenReturn(java.util.Optional.empty());

        org.assertj.core.api.Assertions.assertThatThrownBy(() -> service.findById(id))
                .isInstanceOf(TodoNotFoundException.class)
                .hasMessageContaining(id.toString());
    }
}
