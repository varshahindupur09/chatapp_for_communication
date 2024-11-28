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
public class UserService implements UserDetailsService
{
    @Autowired
    private UserRepository userRepository;

    /**
     * Load a user by username for authentication
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        Optional<User> user = userRepository.findByUsername(username);

        if(!user.isPresent())
        {
            throw new UsernameNotFoundException("User not found with username "+ username);
        }

        return UserPrincipal.create(user.get());
    }

    /**
     * Save a new user to the database
     */
    public User saveUser(User user)
    {
        return userRepository.save(user);
    }

    /**
     * Check if a user exists by username
     */
   public boolean existsByUsername(String username) {
    return userRepository.existsByUsername(username);
    }

} 