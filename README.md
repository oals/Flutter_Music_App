# 📱 AudioX
<img src="https://github.com/user-attachments/assets/871c5e09-27bd-4c4a-a12a-b2716d752f0b" alt="appIcon" width="400"/>

## 📝 소개

**AudioX**는 자작곡을 업로드하고, 다른 사용자들의 곡을 스트리밍할 수 있는 **음악 스트리밍 플랫폼**입니다.  
아티스트와 리스너가 자유롭게 음악을 공유하고 즐길 수 있는 공간을 제공합니다.

---
## 🚀 주요 기능

> 🎧 **자작곡 스트리밍**: 사용자가 직접 업로드한 음원을 감상할 수 있습니다. <br>
> 📡 **끊김 없는 스트리밍**: **HLS 프로토콜 기반**으로 안정적인 음원 재생 경험 제공<br>
> 🎼 **백그라운드 재생 지원**: 화면이 꺼지거나 다른 앱을 사용하는 중에도 음악 재생 유지<br>
> 🚀 **비동기 음원 로딩 최적화**: 음원을 **백그라운드에서 미리 로딩**하여 버벅임 없이 빠른 재생 가능<br>
> 📤 **음원 업로드 기능**: 누구나 자신의 음악을 플랫폼에 업로드할 수 있습니다.<br>
> 📲 **음원 공유 기능**: 카카오톡, 라인, 트위터 등으로 음원 공유 가능 (**딥링크 지원**)<br>
> 🔔 **실시간 알림**: 사용자 활동에 따라 푸시 알림 수신 (**FCM 기반**, **딥링크 지원**)<br>
> 📑 **나만의 플레이리스트 생성**: 좋아하는 곡을 모아 개인 플레이리스트를 만들고 관리할 수 있습니다.<br>
> 🧑‍🤝‍🧑 **팔로우 및 좋아요**: 아티스트를 팔로우하고 곡에 좋아요를 누를 수 있는 소셜 기능 지원<br>


---
## 🛠️ 사용 기술 

> **프로그래밍 언어**: Java 17, Dart 3.4.4  <br>
> **프론트엔드**: Flutter 3.22.3  <br>
> **백엔드**: Spring Boot 3.2.2<br>
> **상태 관리**: Provider<br>
> **데이터베이스**: MySQL  <br>
> **캐싱**: Redis  <br>
> **인증**: JWT 기반 OAuth2 인증 및 보안 적용  <br>
> **미디어 처리**: FFmpeg (음원 변환 및 최적화)  <br>
> **스트리밍**: HLS 프로토콜 기반 오디오 스트리밍  <br>
> **푸시 알림**: FCM (Firebase Cloud Messaging)  <br>
> **클라우드 & 배포**: AWS S3, EC2 Instance  <br>
> **CI/CD**: Jenkins  <br>
---


## 📂 ERD

![ERD](https://github.com/user-attachments/assets/dba772b6-c98b-4833-a695-de9c54bd646f)

---

## 📂 Jenkins


🔧 Config File Provider 사용
- Jenkins의 플러그인을 활용해 설정 파일을 Jenkins에 미리 등록해둡니다.
- 빌드 시 해당 파일들이 자동으로 워크스페이스에 복사되도록 설정하여, 일관된 개발/빌드 환경을 제공합니다.

<img src="https://github.com/user-attachments/assets/f9a931a3-a942-4bc9-a1ec-bbb18b00c753" width="800"/>

<br>

🧪 빌드 자동화: Execute Shell 스크립트


<img src="https://github.com/user-attachments/assets/816a57bb-21ea-44cb-a184-41d8728a36af" width="1200"/>


---

## 📂 Redis


<img src="https://github.com/user-attachments/assets/d527a956-71ec-49ac-836d-404eaa17ad0c" width="700"/>

<br>
<br>


> **audioPlayerTrackIdList/{userId}** – 재생목록 음원 ID 목록 <br> 
> **lastListenTrackId/{userId}** – 마지막으로 청취한 음원 ID <br>
> **lastListenTrackIdList/{userId}** – 마지막으로 청취한 음원들의 목록 <br>


<br>

**모든 키는 userId를 포함하며, 사용자 단위로 데이터를 분리해 관리합니다.**

---



## 📱 목차

> 🎧 **[앱 소개 영상](#-앱-소개-영상-사운드-포함)** <br>
> 🏠 **[홈](#홈)**  <br>
> 🔐 **[로그인](#로그인)**  <br>
> 🎵 **[오디오 플레이어](#오디오-플레이어-사운드-포함)**  <br>
> 📤 **[업로드](#업로드)**  <br>
> 🔔 **[알림](#알림)**  <br>
> 🚀 **[FCM / 딥링크](#FCM--딥링크)**  <br>
> 🔗 **[공유](#공유)**  <br>
> 🔍 **[검색](#검색)**  <br>
> 👤 **[사용자 정보](#사용자-정보)**  <br>
> 🎶 **[음원 상세](#음원-상세)**  <br>
> 📂 **[플레이리스트](#플레이리스트)**  <br>
> ➕ **[팔로우](#팔로우)**  <br>
> ❤️ **[좋아요](#좋아요)** <br>

---


## 📸 앱 소개 영상 (사운드 포함)

https://github.com/user-attachments/assets/78430b3b-e101-4280-a69f-130051011596

---


### 홈

| 홈 |
|---------|
| <img src="https://github.com/user-attachments/assets/5c9ecf45-9478-4c45-a314-62fcf2f22f6b" width="300"/> |

#### ✅ 홈 설명
- **추천 음원 / 플레이리스트 / 앨범**  
  사용자의 검색 기록, 좋아요를 누른 음원, 플레이리스트, 앨범, 팔로우한 사용자 데이터를 기반으로 취향에 콘텐츠를 선별해 보여줍니다.

- **추천 사용자**  
  랜덤 알고리즘을 통해 다양한 사용자 프로필을 소개합니다.<br>
  (업로드한 음원이 존재하는 사용자만 나타냅니다)


---


### 로그인

| 로그인 화면 | 계정 선택  |
|---------|---------|
|<img src="https://github.com/user-attachments/assets/e5a8fbc3-4f48-48c1-9241-e241ec127f8a" width="300"/>|<img src="https://github.com/user-attachments/assets/304780f3-4212-4a4e-a384-ce03f456f880" width="300"/>|


#### ✅ 로그인 설명
본 서비스는 **OAuth2 프로토콜과 Firebase 인증 시스템**을 기반으로 한 로그인 기능을 제공합니다.

- **Google 계정 로그인**을 통해 간편하게 인증할 수 있으며, 사용자의 로그인 요청 시 OAuth2 흐름을 거쳐 **Access Token**과 **Refresh Token**이 발급됩니다.
- **Firebase Authentication**이 이를 바탕으로 사용자 정보를 안전하게 관리하며, 토큰을 활용한 인증 상태 유지를 통해 **자동 로그인** 기능까지 지원합니다.
- 로그인 이후에는 토큰 만료에 따라 **Refresh Token을 통한 재발급 로직**이 자동으로 수행되어, 사용자는 별도의 로그인 절차 없이 서비스를 계속 이용할 수 있습니다.


---


### 오디오 플레이어 (사운드 포함)

| 앱 내 |  잠금화면 |
|---------|--------|
|<video src="https://github.com/user-attachments/assets/cee6e826-85e5-4e04-a4e8-91c6472d9ac5"> | <video src="https://github.com/user-attachments/assets/3213e1d5-d4d8-41ff-93ef-f1d07fcc17b5"> |

<br>

#### ✅ 오디오 플레이어 설명
- **HLS 프로토콜 기반 음원 스트리밍은 앱 내부의 별도 스레드에서 처리**되어, 메인 UI 흐름과 독립적으로 안정적인 재생이 가능합니다.  
- 이로 인해 **사용자는 페이지를 스와이프하며 콘텐츠를 탐색할 때도 오디오가 끊기지 않고 자연스럽게 유지**됩니다.  
- **잠금화면에서도 재생 제어가 가능**하여, 앱을 열지 않고도 음악을 조작할 수 있습니다

<br>

### 오디오 플레이어 - 재생목록

|재생목록|
|-------|
| <img src="https://github.com/user-attachments/assets/c352d4e3-1ba7-4bd8-9b53-3ede67d9ba6f" width="300"/> <br> <img src="https://github.com/user-attachments/assets/48b08b79-bf21-4e57-ae04-64ba58e7df79" width="300"/> <br> <img src="https://github.com/user-attachments/assets/5d235e8b-b0f8-41f8-be42-a5d59e3deaf8" width="300"/> |




<br>

|재생목록 추가 | 재생목록 제거|
|-------|--------|
| <img src="https://github.com/user-attachments/assets/d9e8350c-4a9e-4f1d-82ff-0d102f4f4ac0" width="300"/>  | <img src="https://github.com/user-attachments/assets/7c85f604-85c0-45d2-ad64-f49d0f216e52" width="300"/> |


<br>

#### ✅ 재생목록 설명
- **한 곡 반복 및 재생목록 반복 기능**을 지원합니다.
- 현재 재생 중인 음원 **바로 앞 위치에 새로운 음원을 추가**할 수 있어, 재생 흐름을 원하는 대로 조정할 수 있습니다.  
- **재생 중인 재생목록에서 현재 음원을 실시간으로 제거**할 수 있어, 듣기 원치 않는 곡을 즉시 제외하는 유연한 재생이 가능합니다.



---


### 업로드

| 음원 업로드 | 앨범 업로드|
|---------|---------|
|<video src="https://github.com/user-attachments/assets/4ce15bd1-a1e3-428a-ac37-ec74051f970d"/>  | <video src="https://github.com/user-attachments/assets/1901b590-ecb7-44e5-955b-4fa7224cf3fa"/> |



#### ✅ 업로드 설명
음원 업로드 기능은 **스트리밍 최적화와 안정적인 저장**을 위해 다음과 같은 기술 스택을 활용합니다:

- **ffmpeg**  
  업로드된 오디오 파일을 HTTP 스트리밍에 최적화된 포맷(HLS)으로 인코딩하기 위해 사용됩니다. 이를 통해 다양한 디바이스에서 빠르고 안정적인 재생이 가능해집니다.

- **HLS (HTTP Live Streaming)**  
  Apple에서 개발한 스트리밍 프로토콜로, 오디오 파일을 작은 단위의 세그먼트로 나누어 전송합니다. 사용자가 재생을 시작하면 순차적으로 세그먼트를 받아오는 방식으로, 버퍼링을 최소화합니다.

- **ts (Transport Stream)**  
  HLS에서 사용하는 세그먼트 파일 포맷입니다. 하나의 오디오 콘텐츠를 여러 개의 `.ts` 파일로 분할하여 구성하게 됩니다.

- **m3u8**  
  `.ts` 파일들의 목록과 순서를 정의한 **플레이리스트 파일**로, 클라이언트는 이 파일을 기반으로 오디오를 순서대로 스트리밍합니다.

- **Amazon S3**  
  변환된 `.ts` 및 `.m3u8` 파일들은 AWS의 객체 저장소인 S3에 저장됩니다. 안정적인 다운로드 속도와 높은 가용성을 통해, 대규모 사용자에게 안정적인 오디오 전송을 보장합니다.


| s3 저장소 - 음원 데이터 |
|---------|
|<img src="https://github.com/user-attachments/assets/21a8ff86-2436-4b2b-95f5-71f0f7f2b1df" width="800"/>  |

---


### 알림

| 음원 이동 | 댓글 이동| 멤버 이동 |
|---------|---------|---------|
|<img src="https://github.com/user-attachments/assets/91b92465-07b7-4b45-9856-c3329ce8bb18" width="300"/>  | <img src="https://github.com/user-attachments/assets/cdd85174-9061-4172-987e-11c9abc75916" width="300"/> | <img src="https://github.com/user-attachments/assets/91d80698-6ce4-47ea-83bc-c38eac8ff0df" width="300"/> |


<br> 

| 전체 읽기 / 전체 삭제 |
|---------|
|<img src="https://github.com/user-attachments/assets/7a8744bb-dee2-44aa-ba75-701ed2464b84" width="300"/>  |


#### ✅ 알림 설명
- **알림 전체 읽기 / 전체 삭제** 기능을 제공하여, 사용자가 빠르게 알림을 정리하고 관리할 수 있습니다.  
- 알림 유형에는 다음과 같은 항목이 포함됩니다:
  - **음원 좋아요 알림**
  - **댓글 작성 알림**
  - **팔로우 알림**

- 각각의 알림을 클릭 시 다음 동작이 수행됩니다:
  - **음원 좋아요 / 댓글 알림**: 해당 음원 상세 페이지로 이동하며, 댓글 알림의 경우 **댓글 모달이 자동으로 열리고, 관련 댓글 위치까지 스크롤**됩니다.
  - **팔로우 알림**: 해당 사용자 정보 페이지로 이동합니다.


---


### FCM / 딥링크

| 포그라운드 | 백그라운드|
|---------|---------|
|<img src="https://github.com/user-attachments/assets/347dd19f-a5cb-4802-81ec-022c219a3a77" width="300"/>  | <img src="https://github.com/user-attachments/assets/1275fc0e-6849-4c9d-a15e-bdc92b7ac1ee" width="300"/> |


#### ✅ FCM / 딥링크 설명
- FCM(Firebase Cloud Messaging)을 통해 수신된 푸시 알림은 **앱이 포그라운드/백그라운드에 관계없이 정확한 위치로 이동하도록 딥링크를 내장**하고 있습니다.  
- 사용자가 푸시 알림을 클릭하면, **일반 알림 클릭과 동일한 방식으로** 다음과 같은 동작이 수행됩니다:
  - **음원 좋아요 / 댓글 알림**: 해당 음원 상세 페이지로 진입하며, 댓글 알림의 경우 **댓글 모달 자동 오픈 및 해당 댓글 위치까지 스크롤**됩니다.
  - **팔로우 알림**: 해당 사용자 정보 페이지로 이동합니다.

- 이 모든 이동은 **딥링크 처리 로직**을 기반으로 하며, 앱이 완전히 종료된 상태에서도 알림 클릭 시 정확한 화면으로 라우팅됩니다.

---


### 공유

| 커스텀 공유 모달 | 기본 공유 모달 |
|---------|---------|
| <img src="https://github.com/user-attachments/assets/37e834e4-b6c5-4d13-9eb8-978f0ea3fb98" width="300"/> | <img src="https://github.com/user-attachments/assets/bf6bc216-4232-446a-b994-ccff2a5d9abc" width="300"/> |

<br>

| 카카오톡 공유 | X 공유 | 라인 공유 |
|---------|---------|---------|
| <img src="https://github.com/user-attachments/assets/dad040d1-fe76-4ed9-abdd-3ec6dfe1345b" width="300"/>|<img src="https://github.com/user-attachments/assets/e04448c1-a14f-412a-be33-67fa6d1a5131" width="300"/>|<img src="https://github.com/user-attachments/assets/290a294e-9757-4fe7-bc53-bec0cbf5b8b2" width="300"/>|


#### ✅ 공유 기능 설명
- 사용자가 **카카오톡, X, 라인 중 설치되지 않은 앱을 공유 대상으로 선택한 경우**, 해당 앱의 **Play 스토어 페이지로 자동 안내**됩니다.
- 카카오톡의 경우 **Kakao Flutter SDK를 사용해 카카오톡 공유 기능을 구현**했습니다.

<br>

#### 🔗 딥링크 동작

| 포그라운드 | 백그라운드 |
|--------|-------|
|<img src="https://github.com/user-attachments/assets/8e1d21e3-1db3-4b91-a35b-c153abb94ed4" width="300"/> |<img src="https://github.com/user-attachments/assets/6d2d41f2-c582-434c-95b6-9b1007c3e55f" width="300"/>|

#### ✅ 외부 앱에서의 딥링크 설명

<pre>
  [카카오톡 / X / 라인]
          ↓ (앱에서 열기)
     [서버 Redirect API]
          ↓ (딥링크 생성)
  [앱 실행 + 특정 페이지 이동]
</pre>


---



### 검색

| 검색 기록 |
|---------|
|<img src="https://github.com/user-attachments/assets/2034b06e-6bb2-46bb-898b-80ff45a9019b" width="300"/> |

<br>

| 검색 결과 |
|---------|
| <img src="https://github.com/user-attachments/assets/266ace54-cf99-4fca-9843-eb5b9cbe32a0" width="300"/>  <img src="https://github.com/user-attachments/assets/3a4a7c3b-a578-4580-9588-663ac6d4fc0d" width="300"/>|
  

#### ✅ 검색 설명
- 사용자가 입력한 검색어에 따라 **사용자, 플레이리스트, 앨범, 음원 정보를 통합적으로 검색**할 수 있습니다.  
- **최근 검색 기록은 최대 30개까지 저장**되며, 초과 시 가장 오래된 항목부터 자동으로 삭제됩니다.

---

### 사용자 정보

| 사용자 정보 |
|---------|
|<img src="https://github.com/user-attachments/assets/4bcd3517-3d01-4451-a679-13b04baf3b52" width="300" />  <img src="https://github.com/user-attachments/assets/233065dc-9677-4270-9153-e3e5a9d8e6e0" width="300" /> |

<br>

| 사용자 정보 변경 |
|---------|
| <img src="https://github.com/user-attachments/assets/6ba1fe6b-27e5-4997-8fab-dbd1b4f43ba3" width="300" /> |


#### ✅ 사용자 정보 설명
- 해당 사용자 페이지에서는 **인기 음원, 생성한 플레이리스트, 앨범, 업로드한 음원**을 확인할 수 있습니다.  
- 본인의 정보일 경우, **프로필 이미지, 닉네임, 소개 문구**를 자유롭게 수정할 수 있습니다.



---


### 음원 상세


<img src="https://github.com/user-attachments/assets/538a4885-8e37-4d19-ae08-01e984bebbf9" width="300"/>


### 음원 상세 모달 

| 음원 소유자 | 일반 사용자  |
|---------|---------|
| <img src="https://github.com/user-attachments/assets/1db214b1-59b1-40d3-88aa-5948a3735352" width="300"/> | <img src="https://github.com/user-attachments/assets/74fdad50-ab22-43bb-bc1b-a6401c1c374a" width="300"/> |


| 공개 음원 | 비공개 음원 |
|---------|---------|
| <img src="https://github.com/user-attachments/assets/5d69a888-16c8-4a5d-bd55-3678a766f01d" width="400"/> | <img src="https://github.com/user-attachments/assets/3da62765-0b8a-4e7d-9391-a9a861d0d816" width="400"/>  |


#### ✅ 음원 상세 기능 설명
- 해당 음원의 **제목, 아티스트, 재생 수, 좋아요 수 등 상세 정보를 확인**할 수 있습니다.  
- **내가 업로드한 음원일 경우**, 해당 음원을 **비공개로 전환**할 수 있으며, 비공개 설정 시 **잠금 아이콘이 표시**됩니다.  
- 비공개 처리된 음원은 **해당 음원 소유자 본인에게만 표시**되며, 다른 사용자에게는 노출되지 않습니다.



---



### 플레이리스트

<img src="https://github.com/user-attachments/assets/36413b83-a2d0-41c0-877a-21e1c27d54bd" width="300"/>

<br> 
<br>

| 플레이리스트 생성 | 플레이리스트 음원 추가 |
|---------|--------|
|<img src="https://github.com/user-attachments/assets/1dde776c-8520-4926-93dc-c7a64b4f69ce" width="300"/> | <img src="https://github.com/user-attachments/assets/32dcdc41-b97f-4c2e-8fcf-d1046d2c7b6d" width="300"/> |

<br> 

| 플레이리스트 - 중복 방지 |
|---------|
|<img src="https://github.com/user-attachments/assets/c638012b-aa50-4f2c-9672-6aa339ac4767" width="300"/>|

#### ✅ 플레이리스트 설명
- 사용자는 원하는 대로 **새로운 플레이리스트를 생성**하여 자신만의 음악 컬렉션을 만들 수 있습니다.  
- 생성한 플레이리스트에는 **음원을 자유롭게 추가할 수 있으며**, 이미 추가된 곡의 경우에는 **추가 이벤트가 비활성화되어 중복 추가를 방지**합니다.

---



### 팔로우 

| 팔로잉 | 팔로워  |
|---------|---------|
|<img src="https://github.com/user-attachments/assets/421d595c-440f-4c12-8935-bc3e0fc07502" width="300"/> | <img src="https://github.com/user-attachments/assets/76fbcd50-05f3-4b78-aecd-93f55c210dfd" width="300"/> |

#### ✅ 팔로우 설명
- 유저 간의 팔로우 관계를 나타내는 화면입니다.
- 나를 팔로우 중인 사용자, 내가 팔로우하고 있는 사용자에 대한 텍스트 메시지가 표시됩니다.


---

### 좋아요
| 음원 | 플레이리스트 | 앨범|
|---------|---------|-------|
|<img src="https://github.com/user-attachments/assets/59319fdf-76cc-4bed-aca3-e1fbf4abf579" width="300"/> | <img src="https://github.com/user-attachments/assets/86295cdb-df5d-4d32-8f5d-c3c9ebe7c6a4" width="300"/>| <img src="https://github.com/user-attachments/assets/5bfc735a-ad18-4907-aa9a-35c1c8c45e85" width="300"/> |

#### ✅ 좋아요 설명
- 좋아요한 음원, 플레이리스트, 앨범은 각 메뉴에서 확인할 수 있습니다.


---



