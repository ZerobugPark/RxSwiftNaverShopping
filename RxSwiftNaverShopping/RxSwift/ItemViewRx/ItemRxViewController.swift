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

    
    
    private let disposeBag = DisposeBag()
    private let itemView = ItemRxView()
    
    let a = Observable.just("")
    
    override func loadView() {
        view = itemView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

       
        itemView.collectionView
            .register(ItemRxCollectionViewCell.self, forCellWithReuseIdentifier: ItemRxCollectionViewCell.id)
    
        

        a.flatMap { _ in
            NetworkManagerRxSwift.shared.callRequest2()
            
        }.subscribe(with: self) { owner, value in
            print(value)
        } onError: { owner, error in
            print("error")
        } onCompleted: { owner in
            print("onCompleted")
        } onDisposed: { owner in
            print("onDisposed")
        }.disposed(by: disposeBag)

        

        
    }
    

  
}

