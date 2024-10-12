//
//  TMDBRouter.swift
//  FilmMark
//
//  Created by 김정윤 on 10/9/24.
//

import Foundation
import Alamofire

enum TMDBRouter {
    case searchMovie(keyword: String, page: Int)
    case searchTV(keyword: String, page: Int)
    case trendingMovie
    case trendingTV
    case genre
    case similarMovie(id: Int)
    case similarTV(id: Int)
}

extension TMDBRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .searchMovie:
            return "search/movie"
        case .searchTV:
            return "search/tv"
        case .trendingMovie:
            return "trending/movie/day"
        case .trendingTV:
            return "trending/tv/day"
        case .genre:
            return "genre/movie/list"
        case .similarMovie(let id):
            return "movie/\(id)/similar"
        case .similarTV(let id):
            return "tv/\(id)/similar"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        return [
            APIKey.Header.accept: APIKey.Header.json,
            APIKey.Header.auth: APIKey.key
        ]
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchMovie(let keyword, let page):
            return [
                URLQueryItem(name: "query", value: keyword),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "ko-KR")
            ]
        case .searchTV(let keyword, let page):
            return [
                URLQueryItem(name: "query", value: keyword),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "ko-KR")
            ]
        case .trendingMovie, .trendingTV, .genre, .similarMovie, .similarTV:
            return [
                URLQueryItem(name: "language", value: "ko-KR")
            ]
        }
    }
}
