# scouter 그래프 분석 방법



## 서버 필수 그래프 목록

서버 모니터링 시 권장하는 그래프는 다음과 같다.

- CPU

- Memory

- Network TX Bytes/RX Bytes

- Swap

  - 성능이 아주 중요한 서비스의 경우 Swap 영역으로 메모리가 넘어가면 안되므로 참고 

  

## Tomcat/Java 필수 그래프 목록

일반적인 운영 서버의 모니터링을 위한 필수 그래프 목록은 다음과 같다.

- GC Count

- GC Time

- Heap User, Heap Memory

- TPS

- Active Service EQ

  - 현재 시점에 어플리케이션에서 수행되고 있는 요청을 나타낸다. 이에 대한 모니터링은 주로 `Active Service EQ` 차트로 하게되는데, 서비스 지연으로 인한 장애를 가장 먼저 발견할 수 있는 차트이다.

    ![img](https://blog.kakaocdn.net/dn/7Wopv/btqAo7KCKQP/4D5dRZh1bCFeXOv1ul0CRK/img.gif)

    위 그림은 다섯개의 인스턴스를 모니터링하고 있으며 숫자는 현재 동시에 실행중인 서비스의 개수를 의미한다. 지연되는 서비스는 3초 이후에는 노란색, 7초 이후에는 빨간색으로 표시된다.

- Active Speed

- XLog



모니터링 시점에 지연되는 부분이 있다면 `Active Service EQ`에서 원인을 파악하는 것이 가장 좋은 방법이다. 하지만 많은 경우에 지나간 이슈에 대해 원인을 파악해야 할 필요가 있으며 이런 경우에 활용하는 것이 `XLog` 차트다.



## Xlog

scouter에서의 XLog는 중요하고 아주 큰 역할을 한다. 왜냐하면 각각의 트랜잭션을 분석하고 시스템의 전반적인 상황을 한눈에 볼 수 있는 산포도(scatter chart)이기 때문이다.



![img](https://files.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-M5HOStxvx-Jr0fqZhyW%2F-MISRH1c7hMhIP0H7Sd0%2F-MISSmWPiDm8rwbIdr2-%2F111.png?alt=media&token=2cb752b1-16db-4ba9-b706-a9c72e158c66)

하나의 점은 하나의 요청을 의미한다. 그래서 이 점들이 어떻게 분포되어 있는지에 따라서 그 서비스가 안정적인지 불안정한 상태인지를 확인할 수 있다. 안정적인 서비스일 수록 점들은 아래쪽에 깔려 있게 된다. 

- x축 : 요청이 종료된 시간
- y축 : 요청의 응답 시간
- 빨간색 점 : 에러
- 회색 점 : 비동기 thread



### XLog 목록

![image-20211026203046278](/Users/addpage/Library/Application Support/typora-user-images/image-20211026203046278.png)

분포된 점들을 마우스로 드래그 하게 되면 해당 요청에 대한 상세한 여러 정보들을 확인할 수 있다.

이 메타 정보를 통해 선택한 점들이 어떤 서비스인지 응답시간은 얼마나 걸렸는지, SQL문이나 API 호출시의 응답시간은 얼마였는지 등의 1차적인 정보를 확인할 수 있다.

- CPU : CPU를 점유한 시간, 단위 밀리초
- SQL Count : SQL 수행 개수, 단위 개수
- SQL Time : SQL 수행 시간, 단위 밀리초
- API Count: API 호출 개수, 단위 개수
- API Time : API 수행 시간, 단위 밀리초
- KBytes : 요청을 처리하는 데 사용한 메모리의 양, 단위 킬로바이트  



### XLog 상세 화면 내용 분석

![img](https://blog.kakaocdn.net/dn/Gh6L6/btqAqgz5nDk/yCN2e8UBGFRqo1Yhr6oDtk/img.png)

XLog의 목록을 통해 기본적인 정보를 파악하였다면 상세 프로파일 정보를 통해 보다 더 정확한 정보를 확인할 수 있다. 상세 프로파일은 기본적으로 SQL 및 Socket 연결, http call및 redis call, aync thread call 등과 같은 연계에 대한 정보를 보여주며, 추가적인 설정을 통해 특정한 패턴의 메소드를 프로파일하게 할 수도 있다.

- txid : 트랜잭션 ID
- objName : 호스트/인스턴스 이름
- thread : 수행한 스레드
- endtime : 요청 종료 시간
- elapsed : 수행 시간
- service : 요청 URL
- ipaddr : 호출한 서버/클라이언트의 IP 및 scouter 사용자 ID
- cpu : CPU 점유 시간 및 요청 처리 시 사용한 메모리 크기
- sqlCount : SQL 개수 및 시간
- userAgent : 호출한 클라이언트의 종류
- group : 요청 그룹
- profileSize : 프로파일 크기



### 메서드 프로파일링 추가하기

메서드 프로파일링 기능을 사용하면 더 자세하게 분석할 수 있다. 설정을 변경하는 방법은 여러 가지가 있지만, 가장 편한 방법은 scouter 클라이언트에서 변경하는 것이다. 해당 애플리케이션의 Configure 메뉴를 클릭하게 되면 아래와 같은 설정 정보 화면을 볼 수 있다. 여기서 원하는 내용을 설정한 후 오른쪽 상단에 있는 디스크 모양을 누르면 저장이 완료된다.

![img](https://files.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-M5HOStxvx-Jr0fqZhyW%2F-MISRH1c7hMhIP0H7Sd0%2F-MISSowUGv0akbER3hnk%2F222.png?alt=media&token=786c20c2-b42d-4cb1-a392-cf41513a732a)



### XLog 사용법 - 필터링

scouter의 XLog는 장애를 보다 빠르고 신속하게 진단할 수 있도록 필터링 기능을 제공한다.

![img](https://files.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-M5HOStxvx-Jr0fqZhyW%2F-MISRH1c7hMhIP0H7Sd0%2F-MISSuEkQV3lA8rfKFAZ%2F333.png?alt=media&token=38fa138e-11c1-4d5f-a40d-7d4cd84da0f8)

왼쪽부터 각각의 아이콘에 대해서 알아보자

- 검색 : 특정 URL이나 화면을 찾기 위한 팝업 메뉴
- SQL Filter : SQL 쿼리에서 수행된 시간만을 확인하기 위한 필터
- API Filter : API 호출 시간만을 확인하기 위한 필터
- Error Filter : Error가 발생한 것들을 확인하기 위한 필터



### XLog 사용법 - 과거 데이터 불러오기

XLog도 다른 그래프들처럼 History 기능을 제공한다. 또는 Summary를 사용하여 다양한 통계 정보들을 확인할 수 있다. 조회한 데이터는 CSV 파일로 저장할 수 있다.

![img](https://files.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-M5HOStxvx-Jr0fqZhyW%2F-MISRH1c7hMhIP0H7Sd0%2F-MISSwUPmPN5f7JaLYiT%2F444.png?alt=media&token=de1b0fdf-80d7-453c-8996-d24d5935296d)



## 참고 

- https://chanchan-father.tistory.com/219