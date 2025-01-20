package com.rohan.speakxdemo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/")
public class HelloController {


    @GetMapping()
    public Map<String, String> home(){
        Map<String, String> response = new HashMap<String, String>();
        response.put("message", "Hello World!");
        response.put("status", "200");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        response.put("version", "1.0.0");
        response.put("user", "rohan");
        response.put("env", "docker");
        return response;
    }
}
