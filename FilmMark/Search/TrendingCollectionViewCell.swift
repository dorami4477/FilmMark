//
//  TrendingCollectionViewCell.swift
//  FilmMark
//
//  Created by 김정윤 on 10/13/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TrendingCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrendingCollectionViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let playButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(contentView.safeAreaLayoutGuide).multipliedBy(0.4)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
        }
        
        playButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func configureView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
        titleLabel.numberOfLines = 2
        titleLabel.font = Fonts.bold16
        playButton.setImage(Icons.playCircle, for: .normal)
        playButton.tintColor = Colors.primaryColor
    }
    
    func configureCell(_ data: Content) {
        titleLabel.text = data.title
        guard let path = data.fullPosterPath else { return }
        guard let url = URL(string: path) else { return }
        posterImageView.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
