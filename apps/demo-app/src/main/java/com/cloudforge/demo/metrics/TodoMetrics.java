package com.cloudforge.demo.metrics;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

@Component
public class TodoMetrics {

    private final Counter created;
    private final Counter updated;
    private final Counter completed;
    private final Counter deleted;

    public TodoMetrics(MeterRegistry registry) {
        created = counter(registry, "create");
        updated = counter(registry, "update");
        completed = counter(registry, "complete");
        deleted = counter(registry, "delete");
    }

    public void recordCreated() { created.increment(); }
    public void recordUpdated() { updated.increment(); }
    public void recordCompleted() { completed.increment(); }
    public void recordDeleted() { deleted.increment(); }

    private Counter counter(MeterRegistry registry, String operation) {
        return Counter.builder("cloudforge.todo.operations")
                .description("CloudForge Todo operation count")
                .tag("operation", operation)
                .register(registry);
    }
}
