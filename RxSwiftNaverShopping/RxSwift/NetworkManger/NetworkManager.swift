//
//  NetworkManager.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation

import RxSwift


enum APIError: Error {
    case invalidURL
}

enum NaverRequestRxSwift {
    
    
    case getInfo(query: String, display: Int, sort: String, startIndex: Int)
    
    var baseURL: String {
        "https://openapi.naver.com/v1/search/shop.json"
    }
    
    
    
    var endPoint: URL {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return urlComponents.url!
        
    }
    
    var header: [String: String] {
        return ["X-Naver-Client-Id": APIKey.clientId,
                "X-Naver-Client-Secret": APIKey.clientSecret]
        
    }
    
    
    private var queryParameters: [String: String] {
        switch self {
        case .getInfo(let query, let display, let sort, let startIndex):
            return [
                "query": query,
                "display": "\(display)",
                "sort": sort,
                "start": "\(startIndex)"
            ]
        }
    }
}






class NetworkManagerRxSwift {
    
    static let shared = NetworkManagerRxSwift()
    
    private init() { }
    
    func callRequest(search: String, filter: String) -> Single<Result<NaverShoppingInfo, APIError>> {
        
        
        return Single<Result<NaverShoppingInfo, APIError>>.create { value in
       
            let url = "https://openapi.naver.com/v1/search/shop.json?"
            
            var urlComponents = URLComponents(string: url)
            let query = URLQueryItem(name: "query", value: search)
            let displayQuery = URLQueryItem(name: "display", value: "100")
            let sortQuery = URLQueryItem(name: "sort", value: filter)
            let startQuery = URLQueryItem(name: "start", value: "1")
            
            urlComponents?.queryItems?.append(contentsOf: [query, displayQuery, sortQuery, startQuery])
            
            
            guard let requestURL = urlComponents?.url else {
                //value(.failure(APIError.invalidURL)) // SINGLE
                // 싱글의 입장에서는 스트림이 유지되도록 성공으로 보냄, 대신, 사용자의 결과에는 실패를 보냄
                
                return Disposables.create { // create()는 별도의 행위가 없을 때 사용
                    print("URL 오류입니당")
                }
            }
            
            var request = URLRequest(url: requestURL)
         
            request.setValue(APIKey.clientId, forHTTPHeaderField: "X-Naver-Client-Id")
            request.setValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    value(.success(.failure(APIError.invalidURL)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    
                    if let status = response as? HTTPURLResponse {
                        print(status.statusCode)
                    }
                    value(.success(.failure(APIError.invalidURL)))
                    
                    
                    return
                }
                
                if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(NaverShoppingInfo.self, from: data)
                        
                       
                        value(.success(.success(result)))
                        //value(.success(.success(result)))
                    } catch { // try에서 오류가 날 경우 catch 구문이 실행 즉, 디코딩 문제
                        value(.success(.failure(APIError.invalidURL)))
                    }
                    
                } else {
                    value(.success(.failure(APIError.invalidURL)))
                }
                
                
            }.resume() //필수
            
            return Disposables.create()
            
        }
    }
    
}


