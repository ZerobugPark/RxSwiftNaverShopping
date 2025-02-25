//
//  SearchRxViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/25/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Kingfisher




final class SearchRxViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let bgImage = UIImageView()
    
    private let viewModel = SearchRxViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "오늘도 쇼핑쇼핑"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        configuration()
        bind() 
    }
    
    private func bind() {
    
        let input = SearchRxViewModel.Input(searchButton: searchBar.rx.searchButtonClicked,
                                            searchText: searchBar.rx.text.orEmpty)
        


        let output = viewModel.transform(input: input)
        
            
        output.alertMsg.asDriver(onErrorJustReturn: "").drive(with: self) { owner, msg in
            let alert = UIAlertController(title: "알림", message: "2글자 이상 입력해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            
            alert.addAction(ok)
            owner.present(alert,animated: true)
            
        }.disposed(by: disposeBag)
        
        output.searchItem.asDriver(onErrorJustReturn: "").drive(with: self) { owner, text in
            let vc = ItemRxViewController()
            
            vc.viewModel.query = text
            
            owner.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBag)
        
        
        
    }

}





extension SearchRxViewController {
    
    private func configuration() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
   
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(bgImage)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            
        }
        bgImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        

    }
    
    private func configureView() {
        let placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchBar.layer.borderWidth = 10
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098035797, green: 0.1098041758, blue: 0.122666128, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.tokenBackgroundColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
       

        bgImage.image = UIImage(named: "flex")

    }

}
