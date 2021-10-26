name: Chapter-5
class: title
# Chapter 5
## Service Discovery

---
name: Service-Discovery-Intro
class: img-right compact
Service Discovery - Intro
-------------------------
.center[![:scale 100%](images/service_registration_catalog.png)]

* DNS 및 API 인터페이스
* 상태 체크 (Health Check)
* Load Balancer 연계
* Kubernetes
* 멀티 클라우드, 멀티 DC

???
The starting point for networking with Consul is the service registry. This integrates health checks and provides DNS and API interfaces to enable any service to discover and be discovered by other services.

Consul can be integrated with other services that manage existing north-south traffic such as a traditional load balancers, and distributed application platforms such as Kubernetes, to provide a consistent registry and discovery service across multiple data centers, clouds, and application platforms.

---
name: Service-Discovery-Lab-Servers
class: img-right compact
Service Discovery - 서버
-------------------------
.center[![:scale 100%](images/consul_dataflow_lan.png)]

* Service catalog 관리
* Raft 기반 데이터 복제

???
Consul's service discovery is backed by a service catalog. The catalog maintains the high-level view of the cluster and is used to expose this information via the various interfaces Consul provides, including DNS and HTTP.

The catalog is maintained only by server nodes because it's replicated via the Raft log to provide a consolidated and consistent view of the cluster.

---
name: Service-Discovery-Lab-Clients
class: img-right compact
Service Discovery - 클라이언트
-------------------------
.center[![:scale 100%](images/consul_health_checks.png)]

* 클라이언트는 로컬의 서비스를 확인
* Gossip 기반 노드 상태 확인(Health Check)
* 상태 변경에 대한 정보 만 서버로 전송
* 상태에 대한 서비스 검색 필터
* 확인 유형 - HTTP, TCP, Script 등

???
Each Consul agent maintains its own set of service registrations and health checks to include overall node health. The agents are responsible for executing their own health checks and updating their local state.


---
name: Service-Discovery-Registration
Service Discovery - 구성
-------------------------
.center[![:scale 45%](images/nginx_service_definition.png)]
.center[Nginx 구성 예제] <br>

???
Configuring a service is pretty straight-forward. Here's an example of a config file to register a simple NGINX service, the health check simple HTTP query on port 80.

---
name: Service-Registry-API
Service Registry - API 인터페이스
-------------------------
.center[![:scale 45%](images/service_registry_api.png)]
.center[API Catalog Request] <br>

???
There are a couple of different ways to discover services. The first is by using the API. The example here uses curl, which is convenient for shell scripts. Applications can do direct HTTP requests using a library that fits the language they are using.

---
name: Service-Registry-DNS
Service Registry - DNS 인터페이스
-------------------------
.center[![:scale 45%](images/service_registry_dns.png)]
.center[DNS Catalog Request] <br>

???
The second way is by using DNS. You can query consul using standard hostname resolution either on the command line using tools like dig, nslookup or host, or within applications using native libraries for hostname resolution.

---
name: Service-Registry-UI
Service Registry - UI
-------------------------
.center[![:scale 60%](images/service_registry_ui.png)]
.center[UI Catalog Request] <br>

???
Finally, you can login to the Consul UI and lookup the details in the web UI.

---
name: Service-Registry-Integration-Consul-Template
class: img-right compact
Integrations - Consul Template
-------------------------
.center[![:scale 100%](images/consul_template_example.png)]

* 코드 변경없이 통합
* 동적 구성 지원
* Load Balancer 구성 관리

???
Rolling out service discovery doesn't need to be complicated. Consul Template is a standalone application that populates values from Consul and dynamically renders updates to any third party configuration files.

A common use case is managing load balancer or proxy configuration files that need to be updated in near-real time. In this way, applications that are not Consul aware can benefit from its dynamic capabilities.

It is also ideal for replacing complicated API queries that often require custom formatting.

---
name: Service-Registry-Integration-DNS
class: img-right compact
Integrations - DNS
-------------------------
.center[![:scale 100%](images/consul_example_dns.png)]

* Zero-touch (수작업없이 구성 변경)
* Round robin load balancing
* 비정상 인스턴스의 자동 필터링

???
Using DNS is a simple way to integrate Consul into an existing infrastructure without any high-touch integration.

---
name: Service-Registry-Integration-Native
class: img-right compact
Integrations - API/Native
-------------------------
.center[![:scale 100%](images/consul_ecosystem_diagram.png)]

* SDKs
* Load balancers
* Proxies
* API gateways
* Monitoring tools

???
By leveraging Consul’s RESTful HTTP API system, the community and vendors are able to integrate with Consul's service registry capabilities.

These integrations include SDKs, load balancers, proxies, API gateways, monitoring tools, and more.

If your application is Consul aware, it can connect directly to the API!

---
name: Service-Registry-Integration-Native
class: img-right compact
Example - Native Consul Integration with F5 BIG-IP
-------------------------
.center[![:scale 100%](images/f5_consul_integration.png)]

F5 BIG-IP AS3 서비스 검색 통합을 통해 Consul은 Consul의 카탈로그를 쿼리하여 주어진 서비스의 변경 사항에 대한 업데이트를 주기적으로 가져오기 때문에 별도의 운영자 개입없이 동적으로 노드 풀을 조정합니다.

.center[
<a href="https://www.hashicorp.com/resources/zero-touch-application-delivery-with-f5-big-ip-terraform-and-consul" target=_blank>HashiCorp F5 Consul Webinar</a>
]

.center[
<a href="https://github.com/hashicorp/f5-terraform-consul-sd-webinar" target=_blank>Webinar Demo Repo</a>
]

.center[
<a href="https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/discovery.html#service-discovery-using-hashicorp-consul" target=_blank>F5 Consul Docs</a>
]

???
We've been working tirelessly with our partners to provide solid and reliable integrations with the tools you may already have. One of those partners is F5. The resources on this page will show you how to dynamically configure your F5 BIG-IP load balancers so you can help your engineering team automate software delivery.
---
name: Service-Registry-Integration-Native-NIA
class: img-right compact
Example - 네트워크 인프라 자동화 (NIA)
-------------------------
네트워크 인프라 자동화를 위한 핵심 구성 요소인 consul-terraform-sync라는 프로세스를 통해, Consul이 감지한 애플리케이션 단의 변경을 자동으로 네트워크 단에 적용하여 트래픽을 처리할 수 있게 합니다.

.center[![:scale 100%](https://github.com/jsp-hashicorp/nia_cts/raw/main/nia.png)]


.center[
<a href="https://learn.hashicorp.com/collections/consul/network-infrastructure-automation" target=_blank>Network Infrastructure Automation(NIA)</a>
]

.center[
<a href="https://github.com/hashicorp/f5-terraform-consul-sd-webinar" target=_blank>Demo Repo</a>
]


???
We've been working tirelessly with our partners to provide solid and reliable integrations with the tools you may already have. One of those partners is F5. The resources on this page will show you how to dynamically configure your F5 BIG-IP load balancers so you can help your engineering team automate software delivery.

---
name: Service-Discovery-Lab
# 👩‍💻 Lab Exercise: Service Discovery
.blocklist[
이 실습에서는 다음을 수행합니다.:

* 서비스 등록
* Health Checks
* 서비스 디스커버리
* 자동화된 구성 관리
* DNS 연계
]

(강사가 실습 환경을 위한 URL을 제공합니다.)
