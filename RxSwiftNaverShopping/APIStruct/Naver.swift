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
    var items: [Item]
  
    
}

struct Item: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    var isLike: Bool //이건 따로 관리해야할거같은데, 필터걸리면 초기화 될 수 있으니까
    
    // enum CodingKeys - 이름 변경 불가
    enum CodingKeys: String, CodingKey {
        case title
        case image
        case lprice
        case mallName
        
    }
    
    //커스텀 디코딩 전략
    init(from decoder: any Decoder) throws {
        // 서버에서 받은 데이터를 한번 더 확인
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(String.self, forKey: .image)
        lprice = try container.decode(String.self, forKey: .lprice)
        mallName = try container.decode(String.self, forKey: .mallName)
        
        isLike = false
    }
}


enum Sorts: String {
    case sim = "sim"
    case date = "date"
    case dsc = "dsc"
    case asc = "asc"

    
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
