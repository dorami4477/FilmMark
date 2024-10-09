//
//  TMDBRouter.swift
//  FilmMark
//
//  Created by 김정윤 on 10/9/24.
//

import Foundation
import Alamofire

enum TMDBRouter {
    
}

extension TMDBRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var endPoint: String {
        switch self {
        
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
        }
    }
}
