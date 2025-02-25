//
//  BaseViewModel.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation


protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
