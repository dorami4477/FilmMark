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
        print(MyFilmRepository.shared.readURL())
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
            guard let posterPath = data.fullPosterPath, let url = URL(string: posterPath) else { return }
            mediaDetailView.posterImageView.kf.setImage(with: url)
        } else {
            guard let myFilm else { return }
            guard let backdropImage = DocumentManager.shared.loadImage(imageName: "\(myFilm.id)_backdrop") else { return }
            mediaDetailView.posterImageView.image = backdropImage
        }
    }
    
    // MARK: SimilarDataSource
    private func configureSimilarDataSource() {
        similarCollectionViewDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfData<Content>>(configureCell: { (dataSource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(item)
            return cell
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            // Header 구성
            guard let self else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaDetailHeaderView.identifier, for: indexPath) as? MediaDetailHeaderView else { return UICollectionReusableView() }
            
            // 저장할 데이터
            var savedata: MyFilm
            var backdropImage = UIImage()
            var posterImage = UIImage()
            
            if let content { // content가 있다면
                header.configureView(with: content)
                savedata = viewModel.contentToFilm(content)
                if let backURL = content.fullBackdropPath, let posterURL = content.fullPosterPath {
                    stringToUIImage([backURL, posterURL]) { value in
                        guard let back = value[0], let poster = value[1] else { return }
                        backdropImage = back
                        posterImage = poster
                    }
                }
            } else { // content가 없고 myFilm이 있다면
                guard let myFilm else { return header }
                header.configureView(with: myFilm)
                savedata = myFilm
                if let poster = DocumentManager.shared.loadImage(imageName: "\(myFilm.id)_poster"),
                   let back = DocumentManager.shared.loadImage(imageName: "\(myFilm.id)_backdrop") {
                    backdropImage = back
                    posterImage = poster
                }
            }
            
            // 저장 버튼 -> Alert
            header.saveButton.rx.tap
                .bind(with: self) { owner, value in
                    owner.presentLikeAlert(savedata, backdropImage: backdropImage, posterImage: posterImage)
                }
                .disposed(by: disposeBag)
            
            return header
        })
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
