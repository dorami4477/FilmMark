# FilmMark
> TMDB API를 사용하여 사용자가 좋아하는 영화・드라마를 즐겨찾기 하고 예고편을 쉽게 찾아볼 수 있는 애플리케이션
<br>

<img src="https://github.com/user-attachments/assets/daa91833-86c1-4962-b987-83b2ff69e75c" width="200"/>
<img src="https://github.com/user-attachments/assets/3bae277a-1253-4dda-a040-c8c7155961cd" width="200"/>
<img src="https://github.com/user-attachments/assets/7d7d0a03-e945-413f-805d-922f7744cecd" width="200"/>
<img src="https://github.com/user-attachments/assets/a8d4bedd-1dfe-4350-8d70-2987e80a5aa3" width="200"/>

## ✅ 개발 환경

- 개발 기간: 2024. 10. 9 ~ 10.14
- 3인 개발: 김정윤, 박다현, 황신혜
- 협업 툴 : 노션, 깃허브
- 최소 버전: iOS(v15.0.0 이상)

  <br>

## ✏️ 협업 작업 규칙

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

    <br>

## 📚 기술 스택

<table>
    <tr>
        <td>UI</td>
        <td>UIKit, Kingfisher, SnapKit</td>
    </tr>
    <tr>
        <td>Network</td>
        <td>Alamofire</td>
    </tr>
    <tr>
        <td>Database</td>
        <td>Realm</td>
    </tr>
    <tr>
        <td>Reactive</td>
        <td>RxSwift, RxDataSources</td>
    </tr>
    <tr>
        <td>API</td>
        <td>TMDB API</td>
    </tr>
    <tr>
        <td>Design Pattern</td>
        <td>MVVM, Input-Output, Router, Repository, Singleton</td>
    </tr>
</table>
<br>

## ⚙️ 기능

- 오늘의 트렌딩 영화 및 TV 프로그램 확인
- TMDB API를 통한 영화 정보 검색
- 영화 즐겨찾기 기능

  <br>

## 🧐 개발 포인트

- Network - Alamofire
    - 코드의 재사용과 네트워크 요청의 일관성을 고려하여 URLRequestConvertible의 TargetType을 활용하여 각 통신에 대한 케이스를 구성
    - 재사용성과 확장성을 고려한 응답 모델 제네릭 활용
    - 네트워크 통신 시, MVVM 내 RxSwift 활용 시 스트림이 끊기지 않도록 Single을 활용
    - 네트워크 결과에 따라 분기처리를 위해 Result type을 활용
    - 네트워크 과호출 방지를 위한 실시간 검색에 디바운싱 기법 적용
    - 콘텐츠 기반 추천 시스템 구현
    - DispatchGroup을 사용한 비동기 이미지 로딩 최적화
- Database - Realm
    - 중복 코드의 최소화와 비즈니스 로직과의 분리를 위해 Repository Pattern을 활용
    - 검색 속도의 향상과 메모리의 효율성을 위해 Realm 모델의 인덱스 활용
    - 대용량 파일 처리와 빠른 접근을 위해 이미지와 데이터의 저장소 분리 및 관리
- MVVM + RxSwift
    - 관심사의 분리로 코드 가독성 및 유지보수성 향상
    - 코드의 유연성 향상을 위한 의존성 주입
- Design
    - 코드 재사용과 일관성을 위한 BaseView 활용
    - 유지보수성 및 재사용성을 고려하여 이미지, 폰트 등 UI 관련 요소 디자인시스템 구축
    - 검색 시, UX를 고려한 명확한 응답 피드백 제공
 
  <br>

## 🛠️ 트러블슈팅

- 비동기 이슈를 해결하기 위해 dispatchGroup 사용

문제

여러 string을 이미지로 변환하여 가져오는 과정에서 모든 이미지가 동시에 반환되지 않음. <br>
또한 UIImage를  처리하는 과정이 global thread에서 실행되며 thread 이슈가 발생함

해결

비동기적으로 받아오는 모든 이미지의 반환 시점을 동일시하기위해 DispatchGroup을 활용. <br>
반환된 이미지를 main thread에서 처리해주도록 변경해주어 thread 이슈 해결

```swift
func stringToUIImage(_ urlStrings: [String], completion: @escaping ([UIImage?]) -> Void) {
    var images: [UIImage?] = Array(repeating: nil, count: urlStrings.count)
    let dispatchGroup = DispatchGroup()

    urlStrings.enumerated().forEach { index, urlString in
        if let url = URL(string: urlString) {
        // 이미지 비동기로 받아오기 시작
            dispatchGroup.enter()
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
	                // 이미지 결과 처리
                    DispatchQueue.main.async {
                        images[index] = value.image
                    }
                case .failure(let error):
                    print("Error loading image: \\(error)")
                    DispatchQueue.main.async {
                        images[index] = nil
                    }
                }
                dispatchGroup.leave()
            }
        } else {
            images[index] = nil
        }
    }
    // 모든 작업 끝났을 때, main에게 알림
    dispatchGroup.notify(queue: .main) {
        completion(images)
    }
}

```

<br>

## 💬 팀 회고
- 실개발 이전에 팀간의 규칙을 정의하고 문서화하여, 개발 도중 생기는 변동사항과 문제상황에서도 유연하게 대처할 수 있었고 명확한 의사소통이 가능하였음. 이를 통해 사전 준비와 체계적인 커뮤니케이션 또한 중요하다는 것을 깨달음.
- Git-flow와 같은 체계적인 브랜치 전략을 통해 프로젝트의 개발 생산성이 향상됨.
    
