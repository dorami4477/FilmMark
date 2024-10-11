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
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .contentsGridLayout())
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        configureSearchController()
        configureCollectionView()
        configureTableView()
    }
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "게임, 시리즈, 영화를 검색하세요 :)"
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func configureCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        collectionView.register(SearchCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier)
    }
    
    private func configureTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.rowHeight = 160
        tableView.sectionHeaderHeight = 40
        tableView.sectionHeaderTopPadding = 0
        tableView.register(SearchTableHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchTableHeaderView.identifier)
    }
}
