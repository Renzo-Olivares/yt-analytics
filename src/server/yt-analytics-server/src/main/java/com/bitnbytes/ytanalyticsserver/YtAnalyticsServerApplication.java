package com.bitnbytes.ytanalyticsserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@SpringBootApplication
public class YtAnalyticsServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(YtAnalyticsServerApplication.class, args);
    }

    // Solution for the following issue
    // CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource
    // https://medium.com/@ashrithgn/spring-config-to-disable-cors-in-spring-boot-fd43bb4bbfa8
    @Configuration
    public class CORSAdvice {
        @Bean
        public FilterRegistrationBean corsFilter() {
            UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
            CorsConfiguration config = new CorsConfiguration();
            config.setAllowCredentials(true);
            config.addAllowedOrigin("*");
            config.addAllowedHeader("*");
            config.addAllowedMethod("*");
            source.registerCorsConfiguration("/**", config);
            FilterRegistrationBean bean = new FilterRegistrationBean(new CorsFilter(source));
            bean.setOrder(0);
            return bean;
        }
    }
}