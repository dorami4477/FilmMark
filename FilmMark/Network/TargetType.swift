//
//  TargetType.swift
//  FilmMark
//
//  Created by 김정윤 on 10/9/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let baseURL = try APIKey.baseURL.asURL()
        let endPoint = baseURL.appendingPathComponent(endPoint)
        var request = try URLRequest(url: endPoint, method: method)
        request.allHTTPHeaderFields = headers
        guard let url = request.url else { return request }
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = queryItems
        // request url을 queryItems 적용한 url로 변경 
        request.url = components?.url
        return request
    }
}
