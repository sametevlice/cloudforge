package com.cloudforge.demo.todo;

import com.cloudforge.demo.metrics.TodoMetrics;
import com.cloudforge.demo.todo.api.CreateTodoRequest;
import com.cloudforge.demo.todo.api.TodoResponse;
import com.cloudforge.demo.todo.api.UpdateTodoRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class TodoService {

    private final TodoRepository repository;
    private final TodoMetrics metrics;

    public TodoService(TodoRepository repository, TodoMetrics metrics) {
        this.repository = repository;
        this.metrics = metrics;
    }

    public List<TodoResponse> findAll() {
        return repository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"))
                .stream()
                .map(TodoResponse::from)
                .toList();
    }

    public TodoResponse findById(UUID id) {
        return TodoResponse.from(getTodo(id));
    }

    @Transactional
    public TodoResponse create(CreateTodoRequest request) {
        Todo todo = new Todo(
                request.title().trim(),
                normalizeDescription(request.description()),
                TodoStatus.PENDING
        );
        Todo savedTodo = repository.save(todo);
        metrics.recordCreated();
        return TodoResponse.from(savedTodo);
    }

    @Transactional
    public TodoResponse update(UUID id, UpdateTodoRequest request) {
        Todo todo = getTodo(id);
        TodoStatus previousStatus = todo.getStatus();

        todo.setTitle(request.title().trim());
        todo.setDescription(normalizeDescription(request.description()));
        todo.setStatus(request.status());

        metrics.recordUpdated();
        if (previousStatus != TodoStatus.COMPLETED && request.status() == TodoStatus.COMPLETED) {
            metrics.recordCompleted();
        }

        return TodoResponse.from(todo);
    }

    @Transactional
    public void delete(UUID id) {
        Todo todo = getTodo(id);
        repository.delete(todo);
        metrics.recordDeleted();
    }

    private Todo getTodo(UUID id) {
        return repository.findById(id)
                .orElseThrow(() -> new TodoNotFoundException(id));
    }

    private String normalizeDescription(String description) {
        if (description == null || description.isBlank()) {
            return null;
        }
        return description.trim();
    }
}
