//
//  BaseViewModel.swift
//  FilmMark
//
//  Created by 박다현 on 10/8/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input:Input) -> Output
}

