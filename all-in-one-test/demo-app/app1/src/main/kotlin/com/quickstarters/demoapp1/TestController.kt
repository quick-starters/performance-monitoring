package com.quickstarters.demoapp1

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.RestTemplate

@RestController
class TestController(
    private val restTemplate: RestTemplate
) {

    @GetMapping("/simple")
    fun simple(): String {
        return "success"
    }

    @GetMapping("/call")
    fun callApp2(): String {
        return restTemplate.getForObject("http://demo-app-2:8080/simple", String::class.java)!!
    }
}
