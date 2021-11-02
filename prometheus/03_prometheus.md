# Prometheus

- 2012년에 처음으로 모습을 드러낸 오픈소스 모니터링 플랫폼
- 기존의 다른 모니터링 플랫폼과는 다르게 Pull 방식을 사용하며, 각 모니터링 대상의 Exporter 또는 Prometheus client를 통해서 지표를 긁어가는(scrape) 방식으로 데이터를 수집합니다.
- Prometheus는 다른 모니터링 플랫폼에 비해 사용과 설정이 간단함에도 불구하고 유연하며 매우 좋을 성능을 내어 많은 사랑을 받아왔습니다.

Prometheus는 Google의 내부 모니터링 시스템이던 Borgmon에 영향을 받아 시작된 Go언어 오픈소스 프로젝트입니다.
2012년부터 꾸준히 커뮤니티가 성장해왔고 현재는 매년 PromCon이라는 컨퍼런스를 진행할 정도로 큰 커뮤니티를 가지게 되었습니다.
또한, CNCF(Cloud Native Computing Foundation)의 Graduated 프로젝트가 되어 현재 컨테이너 모니터링의 사실상 표준처럼 사용되고 있습니다.
Prometheus에 대한 보다 자세한 내용은 생략하고 바로 Prometheus를 사용하여 우리의 애플리케이션을 모니터링할 수 있도록 Prometheus를 사용해보는데 중점을 두도록 하겠습니다.



### Architecture

![img](https://camo.githubusercontent.com/f14ac82eda765733a5f2b5200d78b4ca84b62559d17c9835068423b223588939/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f70726f6d6574686575732f70726f6d65746865757340633334323537643036396336333036383564613335626365663038343633326666643564363230392f646f63756d656e746174696f6e2f696d616765732f6172636869746563747572652e737667)

Prometheus의 구조는 [Prometheus 저장소](https://github.com/prometheus/prometheus)에 나와 있는 아키텍처를 보면 좀 이해하기가 쉽다. 처음에는 꽤 복잡해 보였지만 동작 방식을 이해하면 이 그림을 이해할 수 있게 된다. 

**다른 모니터링 도구와 가장 다른 점은 대부분의 모니터링 도구가 Push 방식 즉, 각 서버에 클라이언트를 설치하고 이 클라이언트가 메트릭 데이터를 수집해서 서버로 보내면 서버가 모니터링 상태를 보여주는 방식인데 반해서 Prometheus는 Pull 방식이다. 그래서 서버가 각 클라이언트를 알고 있어야 하는게 아니라 서버에 클라이언트가 떠 있으면 서버가 주기적으로 클라이언트에 접속해서 데이터를 가져오는 방식이다.**

몇 가지 특징을 짚고 넘어갈 수 있는데 **구성을 크게 나누면 Exporter, Prometheus Server, Grafana, Alertmanager로 나눌 수 있다.** 뒤에서 실제로 사용해 보면 더 이해가 가겠지만, 사전에 알아두어야 할 특징을 정리해 보자.

- Exporter는 모니터링 대상의 Metric 데이터를 수집하고 Prometheus가 접속했을 때 정보를 알려주는 역할을 한다.

   

  호스트 서버의 CPU, Memory 등을 수집하는 node-exporter도 있고 nginx의 데이터를 수집하는 nginx-exporter도 있다. Exporter를 실행하면 데이터를 수집하는 동시에 HTTP 엔드포인트를 열어서(기본은 9100 포트) Prometheus 서버가 데이터를 수집해 갈 수 있도록 한다. 이 말은 웹 브라우저 등에서 해당 HTTP 엔드포인트에 접속하면 Metric의 내용을 볼 수 있다는 의미이다.

  - Exporter를 쓰기 어려운 배치잡 등은 Push gateway를 사용하면 된다. 내가 보기에는 Push gateway도 결국 Exporter의 일종이라고 생각된다.
  - 웹 애플리케이션 서버 같은 경우의 Metric은 클라이언트 라이브러리를 이용해서 Metric을 만든 후 커스텀 Exporter를 사용할 수 있다.

- **Prometheus Server는 Expoter가 열어놓은 HTTP 엔드포인트에 접속해서 Metric을 수집한다.** 그래서 Pull 방식이라고 부른다.

- **Prometheus Server에 Grafana를 연동해서 대시보드 등의 시각화를 한다.**

- **알림을 받을 규칙을 만들어서 Alert Manager로 보내면 Alert Manager가 규칙에 따라 알림을 보낸다.**

내가 그랬듯이 이렇게 특징을 봐도 하나도 이해가 안 갈 텐데 실제로 사용을 해보면 훨씬 쉽게 이해가 되므로 하나씩 살펴보자.



### 로컬 설치

Prometheus는 단일 코드로 여러 운영체제의 바이너리를 빌드할 수 있는 Go 언어로 개발되었습니다.
Go 언어 생태계가 그러하듯 Prometheus도 다양한 운영체제의 바이너리 파일과 컨테이너 이미지를 제공하고 있습니다.
이 문서에서는 컨테이너 환경이 아닌 on-promise 환경을 기준으로 하겠습니다.
하지만 그래도 간단합니다.
우리에게 필요한 운영체제의 바이너리 파일만 다운로드 받아서 실행하면 됩니다.
아래의 페이지를 통해서 다운로드 받을 수 있습니다.

https://prometheus.io/download/

리눅스의 주요 명령어를 활용한다면 아래와 같이 사용할 수도 있을 겁니다.
CentOS7을 사용하였습니다.

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.17.1/prometheus-2.17.1.linux-amd64.tar.gz
tar -xzf prometheus-2.17.1.linux-amd64.tar.gz
```



#### Run

Prometheus의 실행은 매우 간단합니다.
위에서 언급했던 Go 언어는 최종적으로 각 운영체제에도 동작할 수 있는 바이너리를 생성합니다.
일반 바이너리 파일처럼 실행하면 됩니다.

```bash
cd prometheus-2.17.1.linux-amd64
./prometheus
```

끝입니다.
모니터링 지표 수집을 위한 기본적인 준비는 완료되었습니다.
기본적으로 설정 파일은 같은 디렉토리 내의 prometheus.yml을 사용하며 포트는 9090사용합니다.
브라우저를 통해서 `localhost:9090`에 접근하면 아래와 같은 Prometheus 웹 화면이 보일 것입니다.

![10.png](https://image.toast.com/aaaadh/real/2020/techblog/10%284%29.png)

이 웹 화면에서 Prometheus의 조회 쿼리를 테스트해볼 수 있고 추가적인 설정을 통해서 지표 기록 및 알림 상태 등을 확인할 수 있습니다.
하지만 저희가 이 Prometheus 웹 화면을 사용할 일은 거의 없습니다.
저희에게는 Grafana라는 훌륭한 오픈소스 대시보드가 있기 때문입니다.



### 도커 컨테이너로 띄우기



## 참조

- [NHN Cloud](https://meetup.toast.com/posts/237)
- [Prometheus GitHub](https://github.com/prometheus/prometheus)

