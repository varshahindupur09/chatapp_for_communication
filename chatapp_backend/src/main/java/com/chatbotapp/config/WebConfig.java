// WebConfig.java
package com.chatbotapp.config; 

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // Adjust this as per your frontend's port and URL.
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:*", "http://127.0.0.1:*", "http://10.0.0.158:*") // The URL of your frontend app
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}