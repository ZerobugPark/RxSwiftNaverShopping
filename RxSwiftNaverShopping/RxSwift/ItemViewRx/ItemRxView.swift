//
//  ItemRxView.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import UIKit


class ItemRxView: BaseView {

    let resultCountLabel = UILabel()
    let buttonStackView = UIStackView()
    var buttons: [CustomBtn] = []
    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    override func configureHierarchy() {
        self.addSubview(resultCountLabel)
        self.addSubview(buttonStackView)
        self.addSubview(collectionView)
        
        customButtonConfigure()
        for i in 0..<buttons.count {
            buttonStackView.addArrangedSubview(buttons[i])
        }
 
    }
    
    override func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        

    }
    
    override func configureView() {
        resultCountLabel.text = ""
        resultCountLabel.textColor = #colorLiteral(red: 0.4514093995, green: 0.8566667438, blue: 0.5799819827, alpha: 1)
        resultCountLabel.font = .systemFont(ofSize: 14)
        resultCountLabel.textAlignment = .left
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 15
        
        collectionView.backgroundColor = .clear

    }
    
    private func customButtonConfigure() {
        let buttonTitle = [" 정확도 ", " 날짜순 ", " 가격높은순 ", " 가격낮은순 "]
        for i in 0...3 {
            if i > 0 {
                let button = CustomBtn(title: buttonTitle[i], status: false, tagNum: i)
                buttons.append(button)
            } else {
                let button = CustomBtn(title: buttonTitle[i], status: true, tagNum: i)
                buttons.append(button)
            }
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
       
        let inset: CGFloat = 16
        
        layout.itemSize = CGSize(width: 10, height:  10)
        layout.sectionInset = UIEdgeInsets(top: 16, left: inset, bottom: 0, right: inset)
        layout.scrollDirection = .vertical
        
        return layout
    }
}
