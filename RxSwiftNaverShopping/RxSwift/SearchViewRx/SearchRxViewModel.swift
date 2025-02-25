//
//  SearchRxViewModel.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation

import RxSwift
import RxCocoa



final class SearchRxViewModel: BaseViewModel {

    
    
    struct Input {
        let searchButton: ControlEvent<Void>
        let searchText:  ControlProperty<String>
    }
    
    struct Output {
        let alertMsg: PublishRelay<String>
        let searchItem: PublishRelay<String>
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        print("SearchRxViewModel Init")
    }
    
    
    
    
    func transform(input: Input) -> Output {
        
        let alertMsg =  PublishRelay<String>()
        let searchItem =  PublishRelay<String>()
        
        
        input.searchButton.withLatestFrom(input.searchText).bind(with: self) { owner, text in
            
            let result = owner.validation(text)
            
            if result {
                searchItem.accept(text) //방출
            } else {
                let msg = "공백제외 2글자 이상 입렵해주세요"
                alertMsg.accept(msg) //방출
            }
        }.disposed(by: disposeBag)
        
   
        
        return Output(alertMsg: alertMsg, searchItem: searchItem)
    }
    
    
    
    
    private func validation(_ text: String) -> Bool {
                
        let resultStr = text.replacingOccurrences(of: " ", with: "")
        
        if resultStr.count < 2 {
           return false
        } else {
            return true
        }
        
    }
    
    deinit {
        print("SearchRxViewModel DeInit")
    }
}
