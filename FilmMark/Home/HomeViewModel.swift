//
//  HomeViewModel.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let movieList: Observable<[Content]>
        let tvList: Observable<[Content]>
        let mainMedia: Observable<Content>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[Content]>()
        let tvList = PublishSubject<[Content]>()
        let mainMedia = PublishSubject<Content>()
        
        input.viewDidLoad
            .flatMap { _ in
                Single.zip(
                    NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingMovie),
                    NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingTV)
                )
                .asObservable()
            }
            .subscribe(with: self) { owner, result in
                let (movieResult, tvResult) = result
                
                switch (movieResult, tvResult) {
                case (.success(let movieValue), .success(let tvValue)):
                    movieList.onNext(movieValue.results)
                    tvList.onNext(tvValue.results)
                    
                    let combinedResults = movieValue.results + tvValue.results
                    if let randomMedia = combinedResults.randomElement() {
                        mainMedia.onNext(randomMedia)
                    }
                    
                case (.failure(let movieError), _):
                    print("Movie fetch error: \(movieError)")
                    
                case (_, .failure(let tvError)):
                    print("TV fetch error: \(tvError)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: movieList, tvList: tvList, mainMedia: mainMedia)
    }
    
}

