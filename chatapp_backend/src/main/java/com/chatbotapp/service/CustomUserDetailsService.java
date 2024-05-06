// com.chatbotapp.service.CustomUserDetailsService.java
package com.chatbotapp.service;

import com.chatbotapp.model.User;
import com.chatbotapp.repository.UserRepository;
import com.chatbotapp.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<User> user = userRepository.findByUsername(username);

        if (!user.isPresent()) {
            throw new UsernameNotFoundException("User not found with username " + username);
        }

        return UserPrincipal.create(user.get());
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    // creating loadUserById if needed for JWT later (just in case)
    public UserDetails loadUserById(Long id) {
        Optional<User> user = userRepository.findById(id);

        if (!user.isPresent()) {
            throw new UsernameNotFoundException("User not found with id: " + id);
        }

        return UserPrincipal.create(user.get());
    }
}

// Custom UserDetailsService: This service will load user details (such as username and password) 
// from MySQL database.
// It's injected with @Autowired and passed to the AuthenticationManagerBuilder in configure().