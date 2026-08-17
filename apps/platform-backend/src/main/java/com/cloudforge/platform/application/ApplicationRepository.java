package com.cloudforge.platform.application;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ApplicationRepository
    extends JpaRepository<CloudApplication, UUID> {

    boolean existsByNameIgnoreCase(String name);

    boolean existsByRepositoryUrl(String repositoryUrl);
}
