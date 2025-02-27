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



final class SearchRxViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let bgImage = UIImageView()
    
    private let textField = UISearchBar()
    private let label = UILabel()
    
    private let viewModel = SearchRxViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    private let rightButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "오늘도 쇼핑쇼핑"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        
        navigationItem.rightBarButtonItem = rightButton
        
        // 블로그 개꿀
        textField.rx.searchButtonClicked.bind(with: self) { owner, _ in
            //let disposeBag = DisposeBag()
            owner.textField.rx.text.orEmpty.bind(with: owner) { owner, text in
                
                owner.label.text = text
            }.dispose()
            
        }.disposed(by: disposeBag)
        
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
        
        
        rightButton.rx.tap.bind(with: self) { owner, _ in
            
            let vc = WishListViewController()
            
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
        //view.addSubview(bgImage)
        view.addSubview(textField)
        view.addSubview(label)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            
        }
//        bgImage.snp.makeConstraints { make in
//            make.center.equalTo(view.safeAreaLayoutGuide)
//        }
//        
        textField.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
            make.height.equalTo(50)
            
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(50)
            
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
       
        textField.backgroundColor = .red
        label.backgroundColor = .white
        
        bgImage.image = UIImage(named: "flex")

    }

}
