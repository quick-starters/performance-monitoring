package com.quickstarters.demoapp2

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class TestController {

    @GetMapping("/simple")
    fun simple(): String {
        return "simple"
    }
}
