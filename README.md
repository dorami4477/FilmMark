# FilmMark
> TMDB API를 사용하여 사용자가 좋아하는 영화・드라마를 즐겨찾기 하고 예고편을 쉽게 찾아볼 수 있는 앱입니다.

## 개발 환경

- 개발 기간: 2024. 10. 9 ~ 10.14
- 3인 개발: 김정윤, 박다현, 황신혜
- 협업 툴 : 노션, 깃허브
- 최소 버전: iOS(v15.0.0 이상)

## 기능

- 오늘의 트렌딩 영화 및 TV 프로그램 확인
- TMDB API를 통한 영화 정보 검색
- 영화 즐겨찾기 기능

## 기술 스택

| UI | UIKit, Kingfisher, SnapKit |
| --- | --- |
| Network | Alamofire |
| Database | Realm |
| Reactive | RxSwift,  RxDataSources |
| API | TMDB API |
| Design Pattern | MVVM, Input-Output, Router, Repository, Singleton |

## 개발 포인트

- Network - Alamofire
    - 코드의 재사용과 네트워크 요청의 일관성을 고려하여 URLRequestConvertible의 TargetType을 활용하여 각 통신에 대한 케이스를 구성
    - 네트워크 통신 시, MVVM 내 RxSwift 활용 시 스트림이 끊기지 않도록 Single을 활용
    - 네트워크 결과에 따라 분기처리를 위해 Result type을 활용
    - 네트워크 과호출 방지를 위한 실시간 검색에 디바운싱 기법 적용
- Database - Realm
    - 중복 코드의 최소화와 비즈니스 로직과의 분리를 위해 Repository Pattern을 활용
    - 검색 속도의 향상과 메모리의 효율성을 위해 Realm 모델의 인덱스 활용
- MVVM + RxSwift
    - 관심사의 분리로 코드 가독성 및 유지보수성 향상
 
## 협업 작업 규칙

- 작업 분배
    - 작업 효율을 높이기 위한 공통 항목들의 선별 및 컴포넌트화
    - 각각의 핵심 기능을 기준으로 하여 역할 분배
    - 핵심 기능: Home(Trending), Search, Myfilm
- 작업 커뮤니케이션
    - Conflict 방지 및 작업의 효율성을 위해 차트를 통해 진행상황 공유
    - Pull Request 및 기타 요청에 반드시 응답 남기기
- 코드 컨벤션
    - Swift Style Guide - Google
- 커밋 커벤션
    - Karma Git Commit Message Style
- 브랜치 전략
    - Github-Flow 전략을 기반으로 하여 변경 사항을 빠르게 반영할 수 있도록 함
    - 메인브랜치 main과 보조브랜치 feature를 사용
    - feature 브랜치 내에서 /(슬래쉬)를 통해 각자 맡은 파트와 개발 기능을 명시함
        - ex) feature/trending/interface
      
## 폴더 트리
  ```
  FilmMark
├── RxDataSources
│   └── SectionOfData
├── Extension
├── CustomView
├── Database
│   ├── MyFilm
│   ├── MyFilmRepository
│   └── DocumentManager
├── APIKey
├── Network
│   ├── Model
│   └── NetworkService
├── DesignSystem
├── Home
│   ├── HomeViewController
│   ├── HomeView
│   └── HomeViewModel
├── Search
│   ├── SearchViewController
│   ├── SearchColl...eaderView
│   ├── SearchView
│   └── SearchViewModel
│       └── TrendingC...ionViewCell
├── MyFilm
│   ├── MyFilmViewController
│   ├── MyFilmView
│   ├── MyFilmTableViewCell
│   └── MyFilmViewModel
├── MediaDetail
│   ├── MediaDet...Controller
│   ├── MediaDetailView
│   ├── MediaDet...iewModel
│   └── MediaDetailHeaderView
├── Base
│   ├── BaseViewController 
│   ├── BaseViewModel
│   ├── BaseView
│   └── TabBarController
├── AppDelegate
├── SceneDelegate
└── ViewController
  ```
     
## 연락처

프로젝트 관리자: <br>
김정윤 [kkanyo04@naver.com](mailto:kkanyo04@naver.com) / https://github.com/jeongyun-kim<br>
박다현 [dahyun4477@gmail.com](mailto:dahyun4477@gmail.com) / https://github.com/dorami4477<br>
황신혜 [hwang.sine@gmail.com](mailto:hwang.sine@gmail.com) / https://github.com/rikyu-cha
