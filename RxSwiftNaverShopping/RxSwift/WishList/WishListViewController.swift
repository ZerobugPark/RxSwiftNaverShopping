//
//  WishListViewController.swift
//  RxSwiftNaverShopping
//
//  Created by youngkyun park on 2/26/25.
//

import UIKit

final class WishListViewController: UIViewController {
    
    
    enum Section: CaseIterable {
        case main
    }
    
    struct WishList: Hashable, Identifiable {
        let id = UUID()
        let item: String
        let date: String
    
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, WishList>!
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private let searchBar = UISearchBar()
    
    private var list: [WishList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configurationLayout()
        configureDataSource()
        configureDataSource()
        searchBar.delegate = self
        collectionView.delegate = self
    }
    
    
    
    private func configureDataSource() {
        
        
        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, WishList> = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.item
            content.textProperties.color = .black
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            
            content.secondaryText = itemIdentifier.date
            content.textProperties.color = .systemGray
            content.textProperties.font = .systemFont(ofSize: 13)
           
            content.image = UIImage(systemName: "star")
            content.imageProperties.tintColor = .systemRed
            
            cell.contentConfiguration = content
            
            var backGroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backGroundConfig.backgroundColor = .white
            backGroundConfig.cornerRadius = 5
            backGroundConfig.strokeWidth = 2
            backGroundConfig.strokeColor = .systemGray6
            
            cell.backgroundConfiguration = backGroundConfig
            
            
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        
    }
    
    private func updataSnapshot() {
        
        var snopshot = NSDiffableDataSourceSnapshot<Section, WishList>()
        
        snopshot.appendSections(Section.allCases)
        snopshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snopshot)
        
    }
    
    
    
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .black
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        
        return layout
    }


}
// MARK: - CollectionViewDelegate Delegate
extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        list.remove(at: indexPath.item)
        updataSnapshot()
    }
}


// MARK: - SearchBar Delegate
extension WishListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH.mm"
        let date = dateFormatter.string(from: Date())
        
        let item = WishList(item: text, date: date)
        
        for item in list {
            if item.item == text {
                return
            }
        }
        
        list.append(item)
        updataSnapshot()
        
    }
}


// MARK: - layOut
extension WishListViewController {
    
    
    private func configurationLayout() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.backgroundColor = .clear
        collectionView.backgroundColor = .black
    }
}
