//
//  MediaDetailViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Kingfisher

class MediaDetailViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    var data: Content?
    
    private let mediaDetailView = MediaDetailView()
    private let viewModel = MediaDetailViewModel()
    
    override func loadView() {
        view = mediaDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureContent()
    }
    
    private func bindViewModel() {
        guard let data = data else { return }
        
        let input = MediaDetailViewModel.Input(
            content: Observable.just(data),
            viewDidLoad: Observable.just(()),
            addButtonTap: mediaDetailView.saveButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.similarContent
            .bind(to: mediaDetailView.similarContentCollectionView.rx.items(cellIdentifier: ContentsCollectionViewCell.id, cellType: ContentsCollectionViewCell.self)) { (index, item, cell) in
                if let posterPath = item.fullPosterPath, let url = URL(string: posterPath) {
                    cell.imageView.kf.setImage(with: url)
                }
            }
            .disposed(by: disposeBag)
        
        mediaDetailView.playButton.rx.tap
            .bind {
                print("재생 버튼이 탭되었습니다.")
            }
            .disposed(by: disposeBag)
        
        mediaDetailView.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, value in
                let newMedia = MyFilm(id: value.id, title: value.displayTitle, video: value.video, mediaType: value.mediaType, overview: value.overview, voteAverage: value.formattedVoteAverage)
                
                guard let backURL = value.fullBackdropPath, let posterURL = value.fullPosterPath else { return }
                owner.stringToUIImage([backURL, posterURL]) { value in
                    guard let back = value[0], let poster = value[1] else { return }
                    owner.presentLikeAlert(newMedia, backdropImage: back, posterImage: poster)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureContent() {
        guard let data = data else { return }
        
        if let posterPath = data.fullBackdropPath, let url = URL(string: posterPath) {
            mediaDetailView.posterImageView.kf.setImage(with: url)
        }
        
        mediaDetailView.titleLabel.text = data.displayTitle
        mediaDetailView.descriptionLabel.text = data.overview
        mediaDetailView.ratingLabel.text = data.formattedVoteAverage
    }
}
