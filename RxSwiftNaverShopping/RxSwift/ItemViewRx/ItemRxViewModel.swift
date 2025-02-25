//
//  ItemRxViewModel.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation


import RxSwift
import RxCocoa



final class ItemRxViewModel: BaseViewModel {

    
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let filterButton: Observable<Int>
    }
    
    struct Output {
        let shoppingInfo: BehaviorRelay<[Item]>
        let viewDidLoad: Observable<String>
        let itemInfo: BehaviorRelay<(String)>
        let errorMsg: PublishRelay<String>
        let buttonStatus: PublishRelay<String>
    }
    
    private let disposeBag = DisposeBag()
    
    private var data: [Item] = []
    
    private var filter = Sorts.sim.rawValue
    
    var query = ""
    
    init() {
        print("ItemRxViewModel Init")
    }
    
    
    func transform(input: Input) -> Output {
        
        let shoppingInfo = BehaviorRelay(value: data)
        let title = Observable.just(query)
        let total = BehaviorRelay(value: "")
        let errorMsg = PublishRelay<String>()
        let buttonStatus = PublishRelay<String>()
        
        input.viewDidLoad.flatMap {
            NetworkManagerRxSwift.shared.callRequest(search: self.query, filter: self.filter)
        }.bind(with: self) { owner, response in
            
            switch response {
            case .success(let value):
                owner.data = value.items
                
                shoppingInfo.accept(owner.data)
                
                let msg = value.total.formatted() + " 개의 검색 결과"
                total.accept(msg)
               
            case .failure(let error):
                var msg = ""
                switch error {
                case .invalidURL:
                    msg = "잘못된 URL"
                case .queryCheck:
                    msg = "요청 변수 확인"
                case .authenticationFailed:
                    msg = "인증 실패"
                case .forbid:
                    msg = "HTTPS가 아닌 HTTP로 호출한 경우"
                case .noneApi:
                    msg = "API 없음"
                case .checkHTTPMethod:
                    msg = "메서드 허용 안 함"
                case .limitedRequest:
                    msg = "호출 한도 초과 오류"
                case .serverError:
                    msg = "서버 오ㄹ"
                case .unknown:
                    msg = "알려지지 않음"
                case .JsonError:
                    msg = "Data 확인"
                case .decodingError:
                    msg = "구조체 오류"
                
                }
                
                errorMsg.accept(msg)
            }
            
            
        }.disposed(by: disposeBag)
        
        
        input.filterButton.map { tag in
            switch tag {
            case 0:
                return Sorts.sim.rawValue
            case 1:
                return Sorts.date.rawValue
            case 2:
                return Sorts.dsc.rawValue
            case 3:
                return Sorts.asc.rawValue
            default:
                return Sorts.sim.rawValue
                
            }
            
        }.flatMap{ tag in
            NetworkManagerRxSwift.shared.callRequest(search: self.query, filter: tag)
                .map { response in
                    return (tag, response)
                }
        }
        .bind(with: self) { owner, value in
            
            switch value.1 {
            case .success(let response):
                owner.data = response.items
                shoppingInfo.accept(owner.data)
                buttonStatus.accept(value.0)
            case .failure(let error):
               
                var msg = ""
                switch error {
                case .invalidURL:
                    msg = "잘못된 URL"
                case .queryCheck:
                    msg = "요청 변수 확인"
                case .authenticationFailed:
                    msg = "인증 실패"
                case .forbid:
                    msg = "HTTPS가 아닌 HTTP로 호출한 경우"
                case .noneApi:
                    msg = "API 없음"
                case .checkHTTPMethod:
                    msg = "메서드 허용 안 함"
                case .limitedRequest:
                    msg = "호출 한도 초과 오류"
                case .serverError:
                    msg = "서버 오ㄹ"
                case .unknown:
                    msg = "알려지지 않음"
                case .JsonError:
                    msg = "Data 확인"
                case .decodingError:
                    msg = "구조체 오류"
                
                }
                
                errorMsg.accept(msg)
            }
        
            
            
        }.disposed(by: disposeBag)
     
        return Output(shoppingInfo: shoppingInfo, viewDidLoad: title, itemInfo: total, errorMsg: errorMsg, buttonStatus: buttonStatus)
    }
    
    
    
    
   
    
    deinit {
        print("ItemRxViewModel DeInit")
    }
}

