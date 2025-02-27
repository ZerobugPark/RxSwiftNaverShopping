//
//  ItemRxCollectionViewCell.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import UIKit

import RxSwift
import RxCocoa
import Alamofire
import Kingfisher


final class ItemRxCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ItemRxCollectionViewCell"
    
    
    private let circleView = UIView()
    
    private let labelStackView = UIStackView()
    private let titleLabel = CustomLabel(fontSize: 14, color: .white, bold: false)
    
    
    private let mainImage = UIImageView()
    private let mallNameLabel = CustomLabel(fontSize: 12, color: .lightGray, bold: false)
    private let lpriceLabel = CustomLabel(fontSize: 20, color: .white, bold: true)
    let likeBtn = CustomBtn(imgName: "heart")
    var disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        contentView.addSubview(mainImage)
        contentView.addSubview(labelStackView)
        contentView.addSubview(circleView)
        contentView.addSubview(likeBtn)

        labelStackView.addArrangedSubview(mallNameLabel)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(lpriceLabel)
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(160)
        }

        circleView.snp.makeConstraints { make in
            make.bottom.equalTo(mainImage).offset(-10)
            make.trailing.equalTo(mainImage).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)

        }

        likeBtn.snp.makeConstraints { make in
            make.edges.equalTo(circleView)
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(85)
        }
    }
    
    override func configureView() {
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10

        titleLabel.numberOfLines = 2

        circleView.backgroundColor = .white
        DispatchQueue.main.async {
            self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
        }

        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()

        
    }
    
    func updateItemList(item: Item) {
        
        let url = URL(string: item.image)
        mainImage.kf.setImage(with: url)
        
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                                          with: "",
                                                          options: .regularExpression,
                                                          range: nil)
        
        // 콤마 추가
        if let price = Int(item.lprice) {
            lpriceLabel.text = price.formatted()
        } else {
            lpriceLabel.text = item.lprice
        }
        
    }
    
    deinit {
        print("ItemRxCollectionViewCell Deinit")
    }

    
}



