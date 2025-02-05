//
//  SearchViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: BaseViewController {
    private var searchResultsDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>!
    private var trendingDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>!
    private let main = SearchView()
    private var vm: SearchViewModel!
    private var disposeBag = DisposeBag()
    
    init(vm: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
    }
    
    override func loadView() {
        view = main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTrendingDataSource()
        configureSearchResultsDataSource()
        bind()
    }
    
    override func configureView() {
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = main.searchController
    }
    
    // MARK: 검색결과 DataSource
    private func configureSearchResultsDataSource() {
        searchResultsDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionHeaderView.identifier, for: indexPath) as? SearchCollectionHeaderView else { return UICollectionReusableView() }
            header.configureHeader(titleCase: .search)
            return header
        })
    }
    
    // MARK: 트렌딩 DataSource
    private func configureTrendingDataSource() {
        trendingDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionHeaderView.identifier, for: indexPath) as? SearchCollectionHeaderView else { return UICollectionReusableView() }
            header.configureHeader(titleCase: .trending)
            return header
        })
    }
   
    
    // MARK: bind
    private func bind() {
        let searchKeyword = main.searchController.searchBar.rx.text
        let prefetchedIdxs = main.searchCollectionView.rx.prefetchItems
        let trendContentsTapped = main.trendingCollectionView.rx.modelSelected(Content.self)
        let searchContentsTapped = main.searchCollectionView.rx.modelSelected(Content.self)
        
        let input = SearchViewModel.Input(searchKeyword: searchKeyword, prefetchedIdxs: prefetchedIdxs,
                                          trendContentsTapped: trendContentsTapped, searchContentsTapped: searchContentsTapped)
        let output = vm.transform(input: input)
        
        // 키워드가 비어있는지에 따라 trendingCollectionView 보이거나 안 보이게
        output.isEmptyKeyword
            .map { !$0 }
            .bind(to: main.trendingCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 검색결과의 존재여부에 따라 다르게 처리
        output.isEmptyResults
            .bind(with: self) { owner, value in
                if value {
                    owner.main.searchCollectionView.setEmptyMessage("검색 결과가 없습니다 :(")
                } else {
                    owner.main.searchCollectionView.restore()
                    owner.scrollToTop(owner.main.searchCollectionView)
                }
            }
            .disposed(by: disposeBag)
        
        // 검색결과 dataSource에 반영
        output.searchedResults
            .bind(to: main.searchCollectionView.rx.items(dataSource: searchResultsDataSource))
            .disposed(by: disposeBag)
        
        // 트렌딩 결과 dataSource에 반영
        output.trendingResults
            .bind(to: main.trendingCollectionView.rx.items(dataSource: trendingDataSource))
            .disposed(by: disposeBag)
        
        // 트렌딩 콘텐츠 탭 -> 상세뷰
        output.trendContentsTapped
            .asSignal()
            .emit(with: self) { owner, value in
                let vc = MediaDetailViewController(content: value)
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 검색 콘텐츠 탭 -> 상세뷰
        output.searchContentsTapped
            .asSignal()
            .emit(with: self) { owner, value in
                let vc = MediaDetailViewController(content: value)
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: 검색 후 상단으로 이동
    private func scrollToTop(_ collectionView: UICollectionView) {
        let indexPath = IndexPath(item: 0, section: 0)
        guard let layout = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
           return
        }
        let offset = CGPoint(x: 0, y: layout.frame.minY - 40)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
