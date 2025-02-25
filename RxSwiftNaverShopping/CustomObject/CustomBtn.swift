//
//  CustomBtn.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

class CustomBtn: UIButton {
    
    init(title: String, status: Bool, tagNum: Int) {
        super.init(frame: .zero)
        
        configuration = .youngStyle(title: title, status: status)
        
        tag = tagNum
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    init(imgName: String){
        super.init(frame: .zero)
        setImage(UIImage(systemName: imgName), for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .clear
        tintColor = .black
    }
    
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}

//@available (iOS 15.0, *)
extension CustomBtn.Configuration {
    
    static func youngStyle(title: String, status: Bool) -> UIButton.Configuration {
       
        var config = UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 15)
        config.attributedTitle = AttributedString(title, attributes: titleContainer)

       
        if status {
            config.baseForegroundColor = .black
            config.baseBackgroundColor = .white

        } else {
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .black
        }
        
        config.cornerStyle = .capsule

        
        return config
    }
    
}
