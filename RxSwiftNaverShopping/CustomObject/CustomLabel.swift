//
//  CustomLabel.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

class CustomLabel: UILabel {
    
    init(fontSize: CGFloat, color: UIColor, bold: Bool) {
        super.init(frame: .zero)
        
        textColor =  color
        font = bold ? .boldSystemFont(ofSize: fontSize)  : .systemFont(ofSize: fontSize)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}
