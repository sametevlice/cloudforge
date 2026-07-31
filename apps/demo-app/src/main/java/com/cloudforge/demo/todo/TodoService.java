package com.cloudforge.demo.todo;

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

    public TodoService(TodoRepository repository) {
        this.repository = repository;
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

        return TodoResponse.from(repository.save(todo));
    }

    @Transactional
    public TodoResponse update(UUID id, UpdateTodoRequest request) {
        Todo todo = getTodo(id);
        todo.setTitle(request.title().trim());
        todo.setDescription(normalizeDescription(request.description()));
        todo.setStatus(request.status());

        return TodoResponse.from(todo);
    }

    @Transactional
    public void delete(UUID id) {
        Todo todo = getTodo(id);
        repository.delete(todo);
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
