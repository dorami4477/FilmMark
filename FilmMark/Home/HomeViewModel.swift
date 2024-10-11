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
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .flatMap { _ in
                NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingMovie)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("💥Movie", value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMap { _ in
                NetworkService.shared.fetchResults(model: ContentsBox.self, requestCase: .trendingTV)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("🥰TV", value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
