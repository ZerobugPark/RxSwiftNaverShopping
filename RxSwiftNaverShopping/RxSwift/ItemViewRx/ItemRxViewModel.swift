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
                print(error)
            }
            
            
        }.disposed(by: disposeBag)
        
        
        input.filterButton.map { tag in
            switch tag {
            case 0:
                return Sorts.sim.rawValue
            case 1:
                return Sorts.date.rawValue
            case 2:
                return Sorts.asc.rawValue
            case 3:
                return Sorts.dsc.rawValue
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
                print(error)
            }
        
            
            
        }.disposed(by: disposeBag)
     
        return Output(shoppingInfo: shoppingInfo, viewDidLoad: title, itemInfo: total, errorMsg: errorMsg, buttonStatus: buttonStatus)
    }
    
    
    
    
   
    
    deinit {
        print("ItemRxViewModel DeInit")
    }
}

