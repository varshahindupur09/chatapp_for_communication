package com.chatbotapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.chatbotapp.model.User;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> 
{
    // query method to find username
    Optional<User> findByUsername(String username);
}

