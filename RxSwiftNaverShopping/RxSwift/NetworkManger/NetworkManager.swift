//
//  NetworkManager.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation

import Alamofire
import RxSwift


enum APIError: Error {
    
}

enum NaverRequestRxSwift {
    
    
    case getInfo(query: String, display: Int, sort: String, startIndex: Int)
    
    var baseURL: String {
        "https://openapi.naver.com/v1/search/shop.json"
    }
    
    
    
    var endPoint: URL {
        switch self {
        case.getInfo:
            return URL(string: baseURL)!
        }
        
        
    }
    
    var header: HTTPHeaders {
        return ["X-Naver-Client-Id": APIKey.clientId, "X-Naver-Client-Secret": APIKey.clientSecret]
        
    }
    
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters? {
        switch self {
        case let .getInfo(query: query, display: display, sort: sort, startIndex: startIndex):
            let parameters = ["query": query, "display": String(display), "sort": sort, "start": String(startIndex)]
            return parameters
            
        }
        
    }
    
}

class NetworkManagerRxSwift {
    
    static let shared = NetworkManagerRxSwift()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: NaverRequestRxSwift, type: T.Type) -> Single<Result<T, APIError>> {
        
        return Single<Result<T, APIError>>.create { value in
            
            AF.request(api as! URLRequestConvertible).responseString { value in
                print(value)
            }
            
            
            AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString),headers: api.header).validate(statusCode: 0..<300).responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let val):
                    value(.success(.success(val)))
                case.failure(let error):
                    print(error)
                    //value(.failure(APIError.)
                }
                
                
            }
            
            
            return Disposables.create {
                print("끝")
            }
        }
        
    }
    
        
}
