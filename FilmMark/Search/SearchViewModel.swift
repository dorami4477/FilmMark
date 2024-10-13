//
//  SearchViewModel.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()

    struct Input {
        let searchKeyword: ControlProperty<String?> // 검색 키워드
        let prefetchedIdxs: ControlEvent<[IndexPath]> // 스크롤 된 인덱스
        let trendContentsTapped: ControlEvent<Content> // 트렌딩 영화 눌렀을 때
        let searchContentsTapped: ControlEvent<Content> // 검색된 영화 눌렀을 때
    }
    
    struct Output {
        let isEmptyKeyword: BehaviorRelay<Bool> // 키워드가 비어있는지
        let scrollToTop: PublishRelay<Void> // 상단으로 이동할 타이밍인지
        let isEmptyResults: BehaviorRelay<Bool> // 빈 검색결과인지
        let searchedResults: BehaviorRelay<[SectionOfData<Content>]> // 검색결과
        let trendingResults: BehaviorRelay<[SectionOfData<Content>]>
        let trendContentsTapped: ControlEvent<Content>
        let searchContentsTapped: ControlEvent<Content>
    }
    
    func transform(input: Input) -> Output {
        let isEmptyKeyword = BehaviorRelay(value: true)
        let scrollToTop = PublishRelay<Void>()
        let isEmptyResults = BehaviorRelay(value: true)
        let searchedResults: BehaviorRelay<[SectionOfData<Content>]> = BehaviorRelay(value: [])
        let trendingResults: BehaviorRelay<[SectionOfData<Content>]> = BehaviorRelay(value: [])
        // just data
        var totalPage = 0
        var page = 1
        let keyword = BehaviorRelay(value: "")
        
        // MARK: SearchBar 키워드 변경될 때마다
        input.searchKeyword
            .subscribe(with: self) { owner, value in
                guard let value else { return }
                isEmptyKeyword.accept(value.isEmpty)
                page = 1
                keyword.accept(value)
            }
            .disposed(by: disposeBag)
        
        // MARK: 검색어가 없다면 트렌딩 Movie
        isEmptyKeyword
            .filter { $0 }
            .flatMap { _ in NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingMovie) }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let value):
                    let results = SectionOfData(header: "트렌딩", items: value.results)
                    trendingResults.accept([results])
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색 (30개씩 가져오기)
        keyword
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(isEmptyKeyword)
            .filter { !$0 }
            .withLatestFrom(keyword)
            .flatMap { keyword in
                Single.zip(
                    NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .searchMovie(keyword: keyword, page: page)),
                    NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .searchMovie(keyword: keyword, page: page + 1))
                )}
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case (.success(let beforeData), .success(let afterData)):
                    let totalData = beforeData.results + afterData.results // 최대 40개의 데이터
                    let results = Array(totalData.prefix(30)) // 30개만 잘라서 가져오기
                    totalPage = beforeData.totalPages ?? 0 // 총 페이지수
                    // 검색어 변경돼서 새로운 검색 시
                    if page == 1 {
                        let section = SectionOfData(header: "검색", items: results)
                        searchedResults.accept([section])
                        isEmptyResults.accept(results.isEmpty)
                    } else { // 페이지네이션 중일 때
                        let before = searchedResults.value.map { $0.items }.first ?? []
                        let after = before + results
                        let results = SectionOfData(header: "검색", items: after)
                        searchedResults.accept([results])
                    }
                case (.failure(let beforeError), _):
                    print(beforeError)
                case (_, .failure(let afterError)):
                    print(afterError)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: 페이지네이션
        input.prefetchedIdxs
            .compactMap { $0.last }
            .map { ($0.row, searchedResults.value.map { $0.items }.first?.count ?? 0) } // (스크롤 인덱스, 검색결과 개수)
            .filter { $0.0 >= $0.1 - 5 && page < totalPage }
            .subscribe(with: self, onNext: { owner, row in
                page += 1
                keyword.accept(keyword.value)
            })
            .disposed(by: disposeBag)
        
        return Output(isEmptyKeyword: isEmptyKeyword, scrollToTop: scrollToTop,
                      isEmptyResults: isEmptyResults, searchedResults: searchedResults,
                      trendingResults: trendingResults, trendContentsTapped: input.trendContentsTapped,
                      searchContentsTapped: input.searchContentsTapped)
    }
}
