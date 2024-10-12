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
    }
    
    struct Output {
        let isEmptyKeyword: BehaviorRelay<Bool> // 키워드가 비어있는지
        let scrollToTop: PublishRelay<Void> // 상단으로 이동할 타이밍인지
        let isEmptyResults: BehaviorRelay<Bool> // 빈 검색결과인지
        let searchedResults: BehaviorRelay<[SectionOfData<Content>]> // 검색결과
    }
    
    func transform(input: Input) -> Output {
        let isEmptyKeyword = BehaviorRelay(value: true)
        let scrollToTop = PublishRelay<Void>()
        let isEmptyResults = BehaviorRelay(value: true)
        let searchedResults: BehaviorRelay<[SectionOfData<Content>]> = BehaviorRelay(value: [])
        // just data
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
        
        // MARK: 검색어가 없다면 트렌딩 Movie 넣어주기
        isEmptyKeyword
            .filter { $0 }
            .flatMap { _ in NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingMovie) }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let value):
                    print(value.results)
                    //owner.trendingContents.accept(value.results)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색
        keyword
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(isEmptyKeyword)
            .filter { !$0 }
            .flatMap { _ in NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .searchMovie(keyword: keyword.value, page: page)) }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let value):
                    let data = value.results
                    // 검색어 변경돼서 새로운 검색 시
                    if page == 1 {
                        let section = SectionOfData(header: "검색", items: data)
                        searchedResults.accept([section])
                        isEmptyResults.accept(data.isEmpty)
                    } else { // 페이지네이션 중일 때
                        let before = searchedResults.value.map { $0.items }.first ?? []
                        let after = before + data
                        let results = SectionOfData(header: "검색", items: after)
                        searchedResults.accept([results])
                    }
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(isEmptyKeyword: isEmptyKeyword, scrollToTop: scrollToTop,
                      isEmptyResults: isEmptyResults, searchedResults: searchedResults)
    }
}
