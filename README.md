# 📚 WEDLE(위들): 미리보는 대학 정보

**설명**  
위들은 대학 입시를 준비하는 학생들을 위한 종합 정보 앱으로, 다음과 같은 주요 기능을 제공합니다:  
- 대학교 주변 맛집 및 핫플레이스 추천  
- 입시 일정 캘린더 및 알림 기능  
- 학과 추천 로직 및 개인화된 대학 정보 제공

<img width="563" alt="스크린샷 2024-12-05 오후 7 24 50" src="https://github.com/user-attachments/assets/79760f07-4447-4fdf-9d39-76fa3de6d6dd">


## 주요 기능 및 구현  
### 1. 대학교 주변 맛집 및 핫플레이스 추천  
- KakaoMap API를 활용하여 인기 맛집 및 핫플 정보를 시각화  
- **기술 사용**: MapKit, CoreLocation, Kingfisher  

### 2. 입시 일정 캘린더 및 알림 설정  
- FSCalendar를 커스터마이징하여 입시 일정 표시  
- APNS 및 UserNotifications로 사용자 맞춤형 알림 구현  
- **기술 사용**: FSCalendar, APNS, FCM  

### 3. 비동기 데이터 처리 및 학과 추천 로직  
- Combine의 Publisher를 활용한 데이터 처리  
- 사용자 데이터를 기반으로 맞춤 학과 추천  

## 사용 기술 및 라이브러리  
- **Frontend**: SwiftUI, Combine  
- **Backend**: REST API 통신 (Alamofire)  
- **Database**: UserDefaults, CoreData 연구 중  
- **라이브러리**: FSCalendar, Kingfisher, SnapKit, GoogleMobileAds, SwiftKeyChainWrapper  

## 성과 및 최적화  
### 1. 성능 개선  
- 이미지 캐싱(NSCache) 도입으로 API 호출 이미지 로딩 속도 평균 단축  
- Kingfisher를 사용하여 비동기 이미지 로딩 최적화  

### 2. 네트워크 관리  
- Alamofire와 Combine으로 네트워크 요청 중복 방지 및 실패 시 재시도 로직 구현  
- .adapt와 .retry를 통해 인증 토큰 만료 시 자동 재발급 처리  

## 기술적 도전 과제  
- 사용자 경험(UX)을 개선하기 위한 맞춤형 캘린더 및 알림 시스템 설계  
- CoreData 활용을 통한 데이터 영구 저장 기능 연구  

## 역할  
- **100% 기여**: 앱 설계, UI 개발, 네트워크 관리, 최적화 작업 등 전 과정 단독 수행  

## 성과  
- 학과 추천 및 지역 기반 맛집 추천 시스템으로 사용자들에게 실질적인 도움 제공  
- 사용자 중심의 입시 일정 관리와 알림 기능으로 긍정적인 피드백 확보  
