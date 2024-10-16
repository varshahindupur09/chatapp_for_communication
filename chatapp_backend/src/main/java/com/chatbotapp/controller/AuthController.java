// Controller/AuthController.java
package com.chatbotapp.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import com.chatbotapp.model.User;
import com.chatbotapp.security.JwtTokenProvider;
import com.chatbotapp.service.UserService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private UserService userService;

   @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody Map<String, String> userMap) {
        // Extract username and password directly from Map
        String username = userMap.get("username");
        String password = userMap.get("password");

        // Create and save the user (you may modify this part for simplicity)
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);  // This should ideally be hashed
        userService.saveUser(user);

        return ResponseEntity.ok("User registered successfully");
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginMap) {
        // Directly retrieve the username and password from Map
        String username = loginMap.get("username");
        String password = loginMap.get("password");

        // Authenticate user
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, password)
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Generate JWT Token (if you are using JWT)
        String token = jwtTokenProvider.generateToken(authentication);

        return ResponseEntity.ok(token);  // Return token directly
    }
}