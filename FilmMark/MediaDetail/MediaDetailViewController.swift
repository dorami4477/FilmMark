//
//  MediaDetailViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit
import Kingfisher

class MediaDetailViewController: BaseViewController {
    
    private let mainView = MediaDetailView()
    var data: Content? = nil
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureWithData()
        setupActions()
    }
    
    private func setupCollectionView() {
        mainView.similarContentCollectionView.dataSource = self
        mainView.similarContentCollectionView.delegate = self
        mainView.similarContentCollectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
    }
    
    private func configureWithData() {
        guard let data = data else { return }
        
        if let posterPath = data.fullPosterPath, let url = URL(string: posterPath) {
            mainView.posterImageView.kf.setImage(with: url)
        }
        
        mainView.titleLabel.text = data.displayTitle
        mainView.ratingLabel.text = data.formattedVoteAverage
        mainView.descriptionLabel.text = data.overview
    }
    
    private func setupActions() {
        mainView.playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        mainView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    @objc private func playTapped() {
        //재생버튼 누를때 액션 구현 예정
    }
    
    @objc private func saveTapped() {
        //저장버튼 누늘때 액션 구현 예정
    }
}

extension MediaDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6 // 예시로 6개의 아이템을 표시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as? ContentsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // dummy 이미지 URL
        let imageURL = URL(string: "https://picsum.photos/100/150?random=\(indexPath.item)")
        cell.imageView.kf.setImage(with: imageURL)
        
        return cell
    }
}
