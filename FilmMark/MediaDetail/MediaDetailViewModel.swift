//
//  MediaDetailViewModel.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class MediaDetailViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let content: Observable<Content?>
        let myFilm: Observable<MyFilm?>
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let similarContent: BehaviorRelay<[SectionOfData<Content>]>
        let showAlert: Observable<Content>
    }
    
    func transform(input: Input) -> Output {
        let similarContent = BehaviorRelay<[SectionOfData<Content>]>(value: [])
        let showAlert = PublishSubject<Content>()
        
        input.content
            .compactMap { $0 }
            .flatMap { content -> Observable<Result<ContentsBox, NetworkService.NetworkErrorCase>> in
                let mediaType = content.mediaType ?? "movie"
                let endpoint: TMDBRouter = mediaType == "movie" ? .similarMovie(id: content.id) : .similarTV(id: content.id)
                return NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: endpoint).asObservable()
            }
            .subscribe(onNext: { result in
                switch result {
                case .success(let contentsBox):
                    let results = SectionOfData(header: "상세뷰", items: contentsBox.results)
                    similarContent.accept([results])
                case .failure(let error):
                    print("Error fetching similar content: \(error)")
                }
            })
            .disposed(by: disposeBag)

        input.myFilm
            .compactMap { $0 }
            .subscribe(with: self) { owner, value in
                print(value)
                let results = SectionOfData(header: "상세뷰", items: [Content(id: -1, backdropPath: nil, title: nil, name: nil, overview: nil, posterPath: nil, genreIds: nil, popularity: nil, video: nil, releaseDate: nil, voteAverage: nil, voteCount: nil, mediaType: nil)])
                similarContent.accept([results])
            }
            .disposed(by: disposeBag)
        
        return Output(similarContent: similarContent, showAlert: showAlert)
    }
    
    func contentToFilm(_ content: Content) -> MyFilm {
        return MyFilm(id: content.id, title: content.displayTitle, video: content.video, mediaType: content.mediaType, overview: content.overview, voteAverage: content.formattedVoteAverage)
    }
}
