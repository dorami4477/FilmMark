//
//  HomeViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

final class HomeViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let mainView = HomeView()
    let viewModel: HomeViewModel
    private var movieDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>!
    private var tvDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>!
    private var movieSection: PublishSubject<[SectionOfData<Content>]> = PublishSubject()
    private var tvSection: PublishSubject<[SectionOfData<Content>]> = PublishSubject()

    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.mainMedia
            .bind(with: self) { owner, value in
                guard let imagePath = value.fullPosterPath,
                      let url = URL(string: imagePath) else { return }
                owner.mainView.gradientImageView.imageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        output.movieList
            .bind(with: self) { owner, value in
                owner.movieSection.onNext([
                    SectionOfData(header: "영화", items: value)
                ])
            }
            .disposed(by: disposeBag)
        
        output.tvList
            .bind(with: self) { owner, value in
                owner.tvSection.onNext([
                    SectionOfData(header: "TV", items: value)
                ])
            }
            .disposed(by: disposeBag)
        
        self.movieSection
            .bind(to: mainView.moviesCollectionView.rx.items(dataSource: movieDataSource))
            .disposed(by: disposeBag)
        
        self.tvSection
            .bind(to: mainView.tvCollectionView.rx.items(dataSource: tvDataSource))
            .disposed(by: disposeBag)
    
    }
    
    private func configureDataSource() {
        movieDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData>(
            configureCell: { _, collectionView, indexPath, item in
                return self.configureCell(for: collectionView, at: indexPath, with: item)
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                return UICollectionReusableView()
            }
        )
        
        tvDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData>(
            configureCell: { _, collectionView, indexPath, item in
                return self.configureCell(for: collectionView, at: indexPath, with: item)
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                return UICollectionReusableView()
            }
        )
        
    }
    
    private func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath, with item: Content) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as! ContentsCollectionViewCell
        guard let imagePath = item.fullPosterPath, let url = URL(string: imagePath) else { return UICollectionViewCell() }
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
}
