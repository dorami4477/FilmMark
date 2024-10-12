//
//  ContentsBox.swift
//  FilmMark
//
//  Created by 김정윤 on 10/10/24.
//

import Foundation

struct ContentsBox: Decodable {
    let page: Int
    let results: [Content]
}

struct Content: Decodable {
    let id: Int
    let backdropPath: String?
    let title: String? // movie title
    let name: String? // tv title
    let overview: String?
    let posterPath: String?
    let genreIds: [Int]?
    let popularity: Double?
    let video: Bool?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case popularity
        case video
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
    }
    
    var displayTitle: String {
        return title ?? name ?? "Unknown Title"
    }
}

extension Content {
    private var imagePath: String { // 이미지 링크
        return "https://image.tmdb.org/t/p/w300"
    }
    
    var fullPosterPath: String? { // 포스터 이미지 링크
        guard let path = posterPath else { return nil }
        let result = "\(imagePath)\(path)"
        return result
    }
    
    var fullBackdropPath: String? { // 배경 이미지 링크
        guard let path = backdropPath else { return nil }
        let result = "\(imagePath)\(path)"
        return result
    }
    
    var formattedVoteAverage: String { // 소수점 첫째자리까지 자른 별점 평균값
        guard let voteAverage else { return "0" }
        return String(format: "%.1f", voteAverage)
    }
}
