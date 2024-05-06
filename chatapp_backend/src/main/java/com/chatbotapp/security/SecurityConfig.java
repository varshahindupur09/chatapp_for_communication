// com.chatbotapp.security.SecurityConfig.java
package com.chatbotapp.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;

import com.chatbotapp.service.CustomUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;  // Autowire your filter here

    @Autowired
    private CustomUserDetailsService customUserDetailsService;  // Autowire the CustomUserDetailsService

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
            .antMatchers("/auth/**").permitAll() // Allows public access to /auth endpoints
            .anyRequest().authenticated(); // Protecting other endpoints

        // Add the JWT filter before UsernamePasswordAuthenticationFilter
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // authentication logic goes here (e.g., using UserDetailsService)
        // Using the UserDetailsService for loading users, ensuring my service implements it
        // Use the custom UserDetailsService and BCryptPasswordEncoder
        auth.userDetailsService(customUserDetailsService).passwordEncoder(passwordEncoder());
    }

    // Exposing the AuthenticationManager bean
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    // Defining a PasswordEncoder bean (commonly needed for Spring Security)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

// JWT Filter:
// JwtAuthenticationFilter is a filter that checks for a valid JWT token in the request headers. 
// This is injected with @Autowired and added to the filter chain using http.addFilterBefore()
// If this class is not correctly autowired, Spring won't know about the filter, and the security filter chain won’t use it.

// PasswordEncoder: Using BCryptPasswordEncoder to hash and verify passwords securely.

// Expose AuthenticationManager: authenticationManagerBean() method is overridden to expose 
// AuthenticationManager as a Spring bean, which can then be injected into your controllers 
// (like AuthController) to handle login authentication.