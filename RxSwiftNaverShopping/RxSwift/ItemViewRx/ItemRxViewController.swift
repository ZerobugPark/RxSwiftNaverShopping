//
//  ItemRxViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import UIKit

import RxSwift
import RxCocoa

class ItemRxViewController: UIViewController {

    private let itemView = ItemRxView()
    let viewModel = ItemRxViewModel()
    
    
    private let disposeBag = DisposeBag()
    
    

    
    override func loadView() {
        view = itemView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

       
        itemView.collectionView
            .register(ItemRxCollectionViewCell.self, forCellWithReuseIdentifier: ItemRxCollectionViewCell.id)
    
        bind()

        
    }
    
    private func bind() {
        
        let input = ItemRxViewModel.Input(viewDidLoad: Observable.just(()), filterButton: Observable.merge(itemView.buttons[0].rx.tap.map { self.itemView.buttons[0].tag }, itemView.buttons[1].rx.tap.map { self.itemView.buttons[1].tag }, itemView.buttons[2].rx.tap.map { self.itemView.buttons[2].tag }, itemView.buttons[3].rx.tap.map { self.itemView.buttons[3].tag }))
        
       
        
        let output = viewModel.transform(input: input)
        
        output.shoppingInfo.asDriver()
            .drive(itemView.collectionView.rx.items(cellIdentifier: ItemRxCollectionViewCell.id, cellType: ItemRxCollectionViewCell.self)) { item, element, cell in
            
                cell.updateItemList(item: element)
                
                cell.likeBtn.rx.tap.bind(with: self) { owner, _ in
                    cell.status.toggle()
                   
                    // 기존에는 status관리가 되었는데, Rxswift오면 문제가 생김
                    // 데이터 스트림과 관련이 있는건가? status가 재사용되면서, 이전 값을 가지고 오는 문제가 발생
                    // 기존 델리게이트를 사용했을 때는 이러한 문제는 없었음 재사용은되나, 프로퍼티는 별도로 관리?
                    // 근데, RxSwfit는 별로도 관리하는게 아니라 통으로 재사용?.
                    let image = cell.status ? "heart.fill" : "heart"
                    cell.likeBtn.setImage(UIImage(systemName: image), for: .normal)
                }.disposed(by: cell.disposeBag)
                
                
            }.disposed(by: disposeBag)
        
    
        
        
        itemView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        output.viewDidLoad.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        
        output.itemInfo.asDriver().drive(itemView.resultCountLabel.rx.text).disposed(by: disposeBag)
        
        output.buttonStatus.asDriver(onErrorJustReturn: "").drive(with: self) { owner, value in
            
            var tag = 0
            switch value {
            case Sorts.sim.rawValue:
                tag = 0
            case Sorts.date.rawValue:
                tag = 1
            case Sorts.dsc.rawValue:
                tag = 2
            case Sorts.asc.rawValue:
                tag = 3
            default:
                tag = 0
                
            }
            owner.changeButtonColor(tag: tag)
            
        }.disposed(by: disposeBag)
        
        
        output.errorMsg.asDriver(onErrorJustReturn: "").drive(with: self) { owner, msg in
            let alert = UIAlertController(title: "API 통신 오류", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(ok)
            owner.present(alert, animated: true)
            
            
        }.disposed(by: disposeBag)
    }
    
    
    private func changeButtonColor(tag: Int) {
        //버튼 뷰 업데이트
        for i in 0..<itemView.buttons.count {
            if i == tag {
                itemView.buttons[i].configuration?.baseForegroundColor = .black
                itemView.buttons[i].configuration?.baseBackgroundColor = .white

            } else {
                itemView.buttons[i].configuration?.baseForegroundColor = .white
                itemView.buttons[i].configuration?.baseBackgroundColor = .black

            }
        }
    }
  
}



// MARK: - UICollectionViewDelegateFlowLayOut
extension ItemRxViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = view.frame.width
        
        let spacing: CGFloat = 16
        let inset: CGFloat = 16
        
        let objectWidth = (deviceWidth - (spacing + (inset*2))) / 2
       
        
        return CGSize(width: objectWidth, height: objectWidth * 1.5)
    }
  
}
