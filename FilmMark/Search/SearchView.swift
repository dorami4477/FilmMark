//
//  SearchView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    let searchController = UISearchController(searchResultsController: nil)
    let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .contentsGridLayout())
    let trendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .verticalContentsLayout())
    
    override func configureHierarchy() {
        addSubview(searchCollectionView)
        addSubview(trendingCollectionView)
    }
    
    override func configureLayout() {
        searchCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        trendingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        configureSearchController()
        configureTrendingCollectionView()
        configureSearchCollectionView()
    }
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "게임, 시리즈, 영화를 검색하세요 :)"
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func configureSearchCollectionView() {
        searchCollectionView.keyboardDismissMode = .onDrag
        searchCollectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        searchCollectionView.register(SearchCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier)
    }
    
    private func configureTrendingCollectionView() {
        trendingCollectionView.keyboardDismissMode = .onDrag
        trendingCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        trendingCollectionView.register(SearchCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier)
    }
}
