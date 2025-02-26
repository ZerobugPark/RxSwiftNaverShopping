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
    
    
    private let likeButtonTapped = PublishRelay<Int>()
    
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
        
        let input = ItemRxViewModel.Input(viewDidLoad: Observable.just(()), filterButton: Observable.merge(itemView.buttons[0].rx.tap.map { self.itemView.buttons[0].tag }, itemView.buttons[1].rx.tap.map { self.itemView.buttons[1].tag }, itemView.buttons[2].rx.tap.map { self.itemView.buttons[2].tag }, itemView.buttons[3].rx.tap.map { self.itemView.buttons[3].tag }),
                                          likebuttonTapped: likeButtonTapped)
        
       
        
        let output = viewModel.transform(input: input)
        
        output.shoppingInfo.asDriver()
            .drive(itemView.collectionView.rx.items(cellIdentifier: ItemRxCollectionViewCell.id, cellType: ItemRxCollectionViewCell.self)) { item, element, cell in
            
                cell.updateItemList(item: element)
                
                let image = element.isLike ? "heart.fill" : "heart"
                cell.likeBtn.setImage(UIImage(systemName: image), for: .normal)
                
                //element자체는 let인듯 그렇지, element는 보내준것을 그대로 가져오니 var일 수가 없지 무조건 let
                // 여기서 값을 수정한다는거 자체가 이상한거
                
                cell.likeBtn.rx.tap.bind(with: self) { owner, _ in
                    
                    owner.likeButtonTapped.accept((item))
                    
                    // 셀의 ViewModel을 통해 관리해도 괜찮을 듯
                    //element.isLike.toggle()
                    
                    // 기존에는 status관리가 되었는데, Rxswift오면 문제가 생김
                    // 데이터 스트림과 관련이 있는건가? status가 재사용되면서, 이전 값을 가지고 오는 문제가 발생
                    // 기존 델리게이트를 사용했을 때는 이러한 문제는 없었음 재사용은되나, 프로퍼티는 별도로 관리?
                    // 근데, RxSwfit는 별로도 관리하는게 아니라 통으로 재사용?.
                    
                    // 뇌피셜 - 1. non-RxSwift의 재사용은 이미 화면에 사라진 것은 큐에 집어 넣기 때문에, 상태코드 등은 그대로 사용, 나중에 필요할 때 큐에서 불러오는거
                    // 2. RxSwift에서의 재사용은 따로 큐가 있는게 아니라, 기존에 인덱스가 [0,1,2,3,4,5,6] 이런식으로 구성된다면, 해당 셀을 통채로 재사용하는 개념이기 때문에, 안에 상태코드가 바뀌지 않는 것
                    // 3. 즉 재사용을 위한 큐가 존재하지 않음?
                    // 4. cell.disposeBage을 해제해줘도 구독이 해제되는 것뿐임. (상태가 변하는것은 아님)
                    // 5. 현재 코드상 status를 사용하는 입장에, 2번처럼 그냥 특정 인덱스들이 번갈아가면서 재사용된다면, status는 각 셀마다의 고유의 값이 아닌, 재사용되는 인덱스에 있는 값으로 적용되기 때문에 문제가 발생한다고 판단됨.
                    // 6. 그럼 어디서 관리해줘야할까?
                    // 7. 탭을 눌렀을때 서브젝트로 넘겨줘?. 근데, 재사용될때, 구독이 해제되니 그 또한 문제, 재사용때 다시 구독을 해줘야 하나? 이러면 동작할까??
                    
//                    let image = cell.status ? "heart.fill" : "heart"
//                    cell.likeBtn.setImage(UIImage(systemName: image), for: .normal)
                    
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
