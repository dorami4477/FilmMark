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

        
        return Output()
    }
    
}
