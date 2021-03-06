## scouter를 사용한 장애 패턴

XLog에 어떤 패턴들이 나타나는지와 각 패턴이 나타나는 상황에 대해 간단히 얘기해보자.



### 상어 패턴

![img](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%EC%83%81%EC%96%B4%ED%8C%A8%ED%84%B4.png)

마치 바닷가에 상어가 나타난 것과 비슷한 패턴. 순간적으로 응답 시간이 위로 솟구쳤으며, 굉장히 많이 뭉쳐 있는 것을 볼 수 있다. 일반적으로 이러한 패턴은 특정 URL이 갑자기 많이 호출되었거나 다량의 데이터를 순간적으로 이 서버로 전송했을 때 나타난다.



### 파도 패턴

![image-20211026170202149](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%ED%8C%8C%EB%8F%84%ED%8C%A8%ED%84%B4.png)

가장 아래쪽이 해변가, 윗부분은 바다라고 생각하면 파도가 밀려오는 느낌을 받을 수 있다. 어떤 애플리케이션에서 다른 API 등을 호출할 때 타임아웃이 발생하고, 그때 다시 호출을 요청하는 경우 이와 같은 모양이 나타날 수 있다. 대부분 모니터링하고 있는 서비스의 문제라고 하기보다는 연계된 서비스에 문제가 발생하여 갑자기 이러한 패턴이 나타날 확률이 높다. 연계된 서비스를 확인해보자.



### ㅡㅡ 패턴

![img](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%E3%85%A1%E3%85%A1%ED%8C%A8%ED%84%B4.png)

간혹 장애가 발생했을 때 이러한 줄이 생길 수도 있다. 이 줄은 사용자가 추가한 것이 아니라 애플리케이션이 그린 줄이다. 대부분의 경우 원격 저장소나 원격 서버의 연결이 불가능할 경우 Connection Timeout이 발생하면 이렇게 일직선이 나타난다.



![image-20211026191812162](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%EC%9D%BC%EC%9E%90%ED%8C%A8%ED%84%B42.png)

요청량이 많은 서비스의 경우에 연결이 일부분 불가능할 수 있다. 그럴 경우 위와 같은 패턴이 발생할 수도 있다. 전반적인 응답 속도가 급격히 안 좋아지면서 중간에 일직선으로 Connection Timeout과 관련된 요청들이 빨간 선을 만들어낸다.



### 운석 낙하 패턴

![img](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%EC%9A%B4%EC%84%9D%EB%82%99%ED%95%98%ED%8C%A8%ED%84%B4.png)

오른쪽 상단에 빨간 점이 두 개 존재하는 것을 볼 수 있다. 우주에서 운석이 떨어져서 폭파된 것과 같은 형상을 띌 수 있는데, 이러한 경우에는 일반적으로 오른쪽 상단에 있는 저 빨간 점이 장애를 발생시켰을 확률이 대단히 높다. 저 요청 하나가 들어오면서 WAS나 DB의 CPU 사용량을 점유할 경우, 다른 요청들이 영향을 받기 때문에 이러한 형태가 나타난다. 만약 이러한 문제가 발생했을 때 WAS를 재시작해 버린다면 장애의 원인은 영원히 알 수 없는 미제로 남게 될 수도 있다. 따라서 이러한 상황이 하나의 인스턴스에서 발생했다면 해당 인스턴스를 L4에서 제거하거나 웹 서버와 단절시켜 장애를 발생시킨 숙주가 근거를 남길 때까지 기다리는 것을 추천한다.



### 산불 패턴

![image-20211026192023646](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%EC%82%B0%EB%B6%88%ED%8C%A8%ED%84%B4.png)

장애가 발생하면 이렇게 산불이 난 것과 같은 빨간 점이 대량으로 발생한것을 확인할 수 있다. 이는 Active Service EQ 그래프에 어떤 스레드들이 대기하고 있는지를 잘 확인해 보면 장애의 원인을 보다 빠르게 파악할 수 있다.



### 크리스마스트리 패턴

![img](https://github.com/quick-starters/performance-monitoring/blob/main/scouter/images/%ED%81%AC%EB%A6%AC%EC%8A%A4%EB%A7%88%EC%8A%A4%ED%8A%B8%EB%A6%AC%ED%8C%A8%ED%84%B4.png)

처음 scouter를 운영 서버에 설치하고 이런 그래프를 봤다면 최대한 빨리 scouter 창을 작게 만드는 것을 추천한다(누가 볼지도 모르기 때문이다). 이는 아주 많은 요청에서 불규칙적으로 예외가 발생하고 있고, 그 예외 처리가 제대로 되지 않으면 이렇게 크리스마스트리와 같은 점들이 다양하게 분포한다. 다양한 원인이 있으니 하나씩 확인해보면서 해결할 수 밖에 없다.
