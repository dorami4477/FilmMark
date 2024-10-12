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
    var mainMediaID: Int = 0
    var mainMediaGenre: [Int]?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let movieClicked: ControlEvent<Content>
        let tvClicked: ControlEvent<Content>
        let addButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let movieList: Observable<[Content]>
        let tvList: Observable<[Content]>
        let mainMedia: Observable<Content>
        let movieClicked: ControlEvent<Content>
        let tvClicked: ControlEvent<Content>
        let genreList: Observable<String>
        let showAlert: Observable<Content>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[Content]>()
        let tvList = PublishSubject<[Content]>()
        let mainMedia = PublishSubject<Content>()
        let genreList = PublishSubject<String>()
        let showAlert = PublishSubject<Content>()
        
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
                        owner.mainMediaGenre = randomMedia.genreIds
                        owner.mainMediaID = randomMedia.id
                    }
                    
                case (.failure(let movieError), _):
                    print("Movie fetch error: \(movieError)")
                    
                case (_, .failure(let tvError)):
                    print("TV fetch error: \(tvError)")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.viewDidLoad
            .flatMap { _ in
                NetworkService.shared.fetchResults(model: GenreList.self, requestCase: .genre)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let genreValue):
                    if let ids = owner.mainMediaGenre {
                        _ = ids.map { id in
                            let genres = genreValue.genres.filter { $0.id == id }
                            let genreNames = genres.map { $0.name }
                            let combinedGenres = genreNames.joined(separator: " ")
                            genreList.onNext(combinedGenres)
                        }
                    }
                    
                case .failure(let genreError):
                    print("Genre fetch error: \(genreError)")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.addButtonClicked
            .withLatestFrom(mainMedia)
            .subscribe(with: self, onNext: { owner, value in
                showAlert.onNext(value)
            })
            .disposed(by: disposeBag)
            
        
        return Output(movieList: movieList, tvList: tvList, mainMedia: mainMedia, movieClicked: input.movieClicked, tvClicked: input.tvClicked, genreList: genreList, showAlert: showAlert)
    }
    
}
