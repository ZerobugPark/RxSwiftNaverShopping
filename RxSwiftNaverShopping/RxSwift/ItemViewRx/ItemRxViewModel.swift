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
        
        
        input.viewDidLoad.flatMap {
            NetworkManagerRxSwift.shared.callRequest(search: self.query, filter: self.filter)
        }.bind(with: self) { owner, value in
            
            switch value {
            case .success(let response):
                owner.data = response.items
                shoppingInfo.accept(owner.data)
               
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
                return Sorts.sim.rawValue
            case 3:
                return Sorts.asc.rawValue
            default:
                return Sorts.dsc.rawValue
                
            }
            
        }.flatMap({
            NetworkManagerRxSwift.shared.callRequest(search: self.query, filter: $0)
        })
        .bind(with: self) { owner, value in
            
            switch value {
            case .success(let response):
                owner.data = response.items
                shoppingInfo.accept(owner.data)
               
            case .failure(let error):
                print(error)
            }
        
            
        }.disposed(by: disposeBag)
     
        return Output(shoppingInfo: shoppingInfo, viewDidLoad: title)
    }
    
    
    
    
   
    
    deinit {
        print("ItemRxViewModel DeInit")
    }
}

