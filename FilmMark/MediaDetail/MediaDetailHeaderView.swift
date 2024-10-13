//
//  MediaDetailHeaderView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/13/24.
//

import UIKit
import SnapKit

final class MediaDetailHeaderView: UICollectionReusableView {
    static let identifier = "MediaDetailHeaderView"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [titleLabel, ratingLabel, playButton, saveButton, descriptionLabel, similarContentLabel].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
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
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureView(with content: Content) {
        titleLabel.text = content.displayTitle
        ratingLabel.text = content.formattedVoteAverage
        descriptionLabel.text = content.overview
    }
    
    func configureView(with myFilm: MyFilm) {
        titleLabel.text = myFilm.title
        ratingLabel.text = myFilm.voteAverage
        descriptionLabel.text = myFilm.overview
        similarContentLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
