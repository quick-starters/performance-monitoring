# Spring Boot Actuator 

배포된 어플리케이션의 정보들을 모니터링 툴에서 확인 할 수 있도록 정보를 수집해주는 Spring Boot 모듈이다.



다음의 정보들을 어플리케이션에서 수집할 수 있도록 해준다.

- auditing
- health
- metric



Spring에선 다음의 두 가지 방식으로 수집된 정보를 확인 할 수 있다.

- HTTP endpoint 
- JMX



### Http Endpoint 를 통해 수집

```
http://localhost:8080/actuator
```



```json
// 20211102130552
// http://localhost:8080/actuator

{
  "_links": {
    "self": {
      "href": "http://localhost:8080/actuator",
      "templated": false
    },
    "health": {
      "href": "http://localhost:8080/actuator/health",
      "templated": false
    },
    "health-path": {
      "href": "http://localhost:8080/actuator/health/{*path}",
      "templated": true
    },
    "info": {
      "href": "http://localhost:8080/actuator/info",
      "templated": false
    },
    "prometheus": {
      "href": "http://localhost:8080/actuator/prometheus",
      "templated": false
    }
  }
}
```





## 참고

- [Baeldung](https://www.baeldung.com/spring-boot-actuators)

