//
//  Naver.swift
//  RxSwiftNaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import Foundation


struct NaverShoppingInfo: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
    
}

struct Item: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
}


enum Sorts: String {
    case sim = "sim"
    case date = "date"
    case asc = "asc"
    case dsc = "dsc"
    
}


struct APIParameter {
    var display: Int
    var sort: String
    var startIndex: Int
    lazy var maxNum: Int = display * 1000
    
    var totalCount: Int {
        get {
            display * 1000
        }
        set {
            maxNum = newValue
        }
    }
}
