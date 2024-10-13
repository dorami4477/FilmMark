//
//  MediaDetailViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MediaDetailViewController: BaseViewController {
    private var similarCollectionViewDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>!
    private let disposeBag = DisposeBag()
    private var myFilm: MyFilm?
    private var content: Content?
    
    init(myFilm: MyFilm? = nil, content: Content? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.myFilm = myFilm
        self.content = content
    }
    
    private let mediaDetailView = MediaDetailView()
    private let viewModel = MediaDetailViewModel()
    
    override func loadView() {
        view = mediaDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSimilarDataSource()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = MediaDetailViewModel.Input(
            content: Observable.just(content),
            myFilm: Observable.just(myFilm),
            viewDidLoad: Observable.just(())
        )
     
        let output = viewModel.transform(input: input)
        
        output.similarContent
            .bind(to: mediaDetailView.similarContentCollectionView.rx.items(dataSource: similarCollectionViewDataSource))
            .disposed(by: disposeBag)
    
        mediaDetailView.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        if let data = content {
            configureContent(data)
        } else {
            configureMyFilm()
        }
    }
    
    private func configureContent(_ data: Content) {
        if let posterPath = data.fullBackdropPath, let url = URL(string: posterPath) {
            mediaDetailView.posterImageView.kf.setImage(with: url)
        }
    }
    
    private func configureMyFilm() {
        guard let myFilm else { return }
        guard let backdropImage = DocumentManager.shared.loadImage(imageName: "\(myFilm.id)_backdrop") else { return }
        mediaDetailView.posterImageView.image = backdropImage
    }
    
    private func configureSimilarDataSource() {
        similarCollectionViewDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>(configureCell: { (dataSource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item)
            return cell
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaDetailHeaderView.identifier, for: indexPath) as? MediaDetailHeaderView else { return UICollectionReusableView() }
            
            if let content {
                header.configureView(with: content)
            } else {
                guard let myFilm else { return header }
                header.configureView(with: myFilm)
            }
            
            return header
        })
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
