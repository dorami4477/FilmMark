//
//  NetworkService.swift
//  FilmMark
//
//  Created by 김정윤 on 10/10/24.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    enum NetworkErrorCase: Error {
        case invalidData
    }
    
    func fetchResults<T: Decodable>(model: T.Type, requestCase: TMDBRouter) -> Single<Result<T, NetworkErrorCase>> {
        return Single.create { single in
            do {
                let request = try requestCase.asURLRequest()
                AF.request(request).responseDecodable(of: model.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(.success(value)))
                    case .failure(_):
                        single(.success(.failure(.invalidData)))
                    }
                }
            } catch {
                print("configure request failed")
            }
            return Disposables.create()
        }
    }

}
