//
//  GenreList.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import Foundation

struct GenreList: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
