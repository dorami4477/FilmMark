//
//  FilmTableViewCell.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit
import SnapKit
import Kingfisher

class MyFilmTableViewCell: UITableViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.bold16
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.playCircle, for: .normal)
        button.tintColor = Colors.primaryColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰 설정
    private func setupViews() {
        backgroundColor = .white
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    func configure(with film: MyFilm) {
        titleLabel.text = film.title
        
        if let posterImage = DocumentManager.shared.loadImage(imageName: "\(film.id)_poster") {
            posterImageView.image = posterImage
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }
}
