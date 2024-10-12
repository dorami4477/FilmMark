//
//  MediaDetailView.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit
import SnapKit

class MediaDetailView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Icons.tv
        configuration.baseForegroundColor = Colors.white
        configuration.background.backgroundColor = Colors.black.withAlphaComponent(0.5)
        configuration.background.cornerRadius = 18
        configuration.imagePadding = 8
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13)
        configuration.image = Icons.close?.withConfiguration(imageConfig)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        return button
    }()
    
    let addToListButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Icons.tv
        configuration.baseForegroundColor = Colors.white
        configuration.background.backgroundColor = Colors.black.withAlphaComponent(0.5)
        configuration.background.cornerRadius = 18
        configuration.imagePadding = 8
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13)
        configuration.image = Icons.tv?.withConfiguration(imageConfig)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold20
        label.textColor = Colors.black
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold18
        label.textColor = Colors.black
        return label
    }()
    
    lazy var playButton: RoundRectangleButton = {
        let button = RoundRectangleButton(
            title: "재생",
            bgColor: Colors.systemGray5,
            textColor: Colors.primaryColor,
            icon: Icons.play
        )
        return button
    }()
    
    lazy var saveButton: RoundRectangleButton = {
        let button = RoundRectangleButton(
            title: "저장",
            bgColor: Colors.primaryColor,
            textColor: .white,
            icon: Icons.down
        )
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold14
        label.textColor = Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    let similarContentLabel: UILabel = {
        let label = UILabel()
        label.text = "비슷한 콘텐츠"
        label.font = Fonts.bold18
        label.textColor = Colors.primaryColor
        return label
    }()
    
    let similarContentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = UIScreen.main.bounds.width / 3 - 20
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        return cv
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [posterImageView, closeButton, addToListButton, titleLabel, ratingLabel, playButton, saveButton, descriptionLabel, similarContentLabel, similarContentCollectionView].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(posterImageView).inset(16)
            make.size.equalTo(36)
        }
        
        addToListButton.snp.makeConstraints { make in
            make.top.equalTo(posterImageView).inset(16)
            make.trailing.equalTo(closeButton.snp.leading).offset(-8)
            make.size.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        similarContentLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        similarContentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarContentLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(170)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        scrollView.backgroundColor = Colors.white
        contentView.backgroundColor = Colors.white
    }
}
