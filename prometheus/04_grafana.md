# Grafana



## Grafana란

다양한 데이터소스로부터 데이터를 가져와 대시보드를 구성할 수 있도록 돕는 오픈소스 플랫폼

> ❓ **그라파나가 말하는 데이터 소스란**
>
> 일반적으로 Grafana에서 말하는 데이터소스는 실제 시계열 지표 성격의 데이터를 저장하고 조회할 수 있는 플랫폼. 지원하는 데이터소스의 목록은 [Grafana Docs](https://grafana.com/docs/grafana/latest/datasources/)에서 확인



### 기술 스택

- 백엔드 
  - Go 언어
- 프론트엔드
  - 초창기 Angular, 현재 TypeScript + React



### 프로메테우스

Prometheus 데이터소스는 Grafana official 데이터소스 중 하나이기 때문에 Grafana에 기본적으로 built-in되어있어 저희가 별도로 설치해야할 것은 없습니다.



### 로컬 설치

아래의 페이지에서 Grafana 바이너리와 각 운영체제 및 설치 방법에 따른 가이드가 제공되고 있습니다.
역시 단일 바이너리 형태로 제공되기 때문에 기능 테스트 용도라면 그저 바이너리 파일을 다운로드받아서 간단하게 실행해볼 수 있습니다.

https://grafana.com/grafana/download

```bash
wget https://dl.grafana.com/oss/release/grafana-6.7.2.linux-amd64.tar.gz
tar -zxvf grafana-6.7.2.linux-amd64.tar.gz
```



### 도커 컨테이너로 띄우기



#### Run

standalone으로 실행한다면 별다른 설정이 필요하지 않습니다.
물론, 고가용성 또는 보안(인증, 권한 등)이 필요하거나 많은 트레픽을 처리해야하는 경우 별도의 설정이 필요할 것입니다.

```bash
cd grafana-6.7.2
./bin/grafana-server
```

Grafana 웹서버의 기본 포트는 3000입니다.
브라우저를 통해서 `http://localhost:3000`으로 접속하면 Grafana 로그인 페이지가 보일 것 입니다.

![11.png](https://image.toast.com/aaaadh/real/2020/techblog/11%284%29.png)

기본 관리자 계정은 `ID: admin`, `PW: admin`입니다.
로그인에 성공하면 Grafana에서 다음 단계를 위한 가이드를 보여줄 것 입니다.

#### Add Prometheus Data Source

상단의 `Add data source` 버튼을 클릭하거나 왼쪽 사이드메뉴의 `Configuration > Data sources > Add data source` 버튼을 클릭하여 데이터소스를 추가할 수 있습니다.

![12.png](https://image.toast.com/aaaadh/real/2020/techblog/12%282%29.png)

클릭하면 아래와 같은 화면이 나타납니다.
`Time series databases` 탭에서 `Prometheus` 선택합니다.

![13.png](https://image.toast.com/aaaadh/real/2020/techblog/13%282%29.png)

원하는 이름으로 `Name` 필드를 작성하고 아래 HTTP 탭의 `URL` 필드에서는 조금 전에 설치하여 실행한 Prometheus의 URL을 입력합니다.
Grafana와 Prometheus를 같은 호스트에 설치하였다면 `http://lcoalhost:9090`을 입력하면 될 겁니다.
값을 입력하고 아래의 `Save & Test` 버튼을 클릭하여 데이터소스를 저장합니다.
입력한 설정 값에 문제가 없다면 Success라는 녹색창의 메시지가 노출됩니다.

![14.png](https://image.toast.com/aaaadh/real/2020/techblog/14%283%29.png)

이렇게 간단하게 Prometheus와 Grafana를 연동할 수 있습니다.
제대로 동작하는지 확인을 위해서 새로 대시보드를 생성하여 차트를 만들어볼 수 있습니다.
하지만 현재 모니터링하고 있는 애플리케이션이 없기 때문에 애초에 차트로 만들 것이 없습니다.
(기본 설정상 Prometheus는 자기 자신도 모니터링하기 때문에 수집되는 지표가 존재하기는 하겠지만 여기서는 Java 애플리케이션이 목적이기 때문에 넘어가도록 하겠습니다.)