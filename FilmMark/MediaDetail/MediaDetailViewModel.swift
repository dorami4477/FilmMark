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
        let content: Observable<Content>
        let viewDidLoad: Observable<Void>
        let addButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let similarContent: Observable<[Content]>
        let showAlert: Observable<Content>
    }
    
    func transform(input: Input) -> Output {
        let similarContent = PublishSubject<[Content]>()
        let showAlert = PublishSubject<Content>()
        
        input.content
            .flatMap { content -> Observable<Result<ContentsBox, NetworkService.NetworkErrorCase>> in
                let mediaType = content.mediaType ?? "movie"
                let endpoint: TMDBRouter = mediaType == "movie" ? .similarMovie(id: content.id) : .similarTV(id: content.id)
                return NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: endpoint).asObservable()
            }
            .subscribe(onNext: { result in
                switch result {
                case .success(let contentsBox):
                    similarContent.onNext(contentsBox.results)
                case .failure(let error):
                    print("Error fetching similar content: \(error)")
                    similarContent.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .withLatestFrom(input.content)
            .subscribe(with: self, onNext: { owner, value in
                showAlert.onNext(value)
            })
            .disposed(by: disposeBag)
        
        return Output(similarContent: similarContent.asObservable(), showAlert: showAlert)
    }
}
