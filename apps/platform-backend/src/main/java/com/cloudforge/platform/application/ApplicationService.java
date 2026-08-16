package com.cloudforge.platform.application;

import com.cloudforge.platform.common.DuplicateResourceException;
import com.cloudforge.platform.common.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class ApplicationService {

    private final ApplicationRepository repository;

    public ApplicationService(
        ApplicationRepository repository
    ) {
        this.repository = repository;
    }

    @Transactional
    public ApplicationResponse create(
        CreateApplicationRequest request
    ) {
        String name = request.name().trim();
        String repositoryUrl =
            request.repositoryUrl().trim();

        String defaultBranch =
            request.defaultBranch() == null
                || request.defaultBranch().isBlank()
                ? "main"
                : request.defaultBranch().trim();

        if (repository.existsByNameIgnoreCase(name)) {
            throw new DuplicateResourceException(
                "Application name already exists: " + name
            );
        }

        if (repository.existsByRepositoryUrl(repositoryUrl)) {
            throw new DuplicateResourceException(
                "Repository is already registered: "
                    + repositoryUrl
            );
        }

        CloudApplication application =
            new CloudApplication(
                name,
                repositoryUrl,
                defaultBranch
            );

        return ApplicationResponse.from(
            repository.save(application)
        );
    }

    @Transactional(readOnly = true)
    public List<ApplicationResponse> findAll() {
        return repository
            .findAll()
            .stream()
            .map(ApplicationResponse::from)
            .toList();
    }

    @Transactional(readOnly = true)
    public ApplicationResponse findById(UUID id) {
        return ApplicationResponse.from(
            getEntity(id)
        );
    }

    @Transactional(readOnly = true)
    public CloudApplication getEntity(UUID id) {
        return repository
            .findById(id)
            .orElseThrow(() ->
                new ResourceNotFoundException(
                    "Application not found: " + id
                )
            );
    }
}
