//
//  MediaDetailView.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit
import SnapKit

class MediaDetailView: BaseView {
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
    
    let similarContentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .contentsGridLayout(heightDimensionValue: 0.35))
    
    override func configureHierarchy() {
        [posterImageView, closeButton, addToListButton, similarContentCollectionView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
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

        similarContentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        similarContentCollectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        similarContentCollectionView.register(MediaDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MediaDetailHeaderView.identifier)
    }
}
