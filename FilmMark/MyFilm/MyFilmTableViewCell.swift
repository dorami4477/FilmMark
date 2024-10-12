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
    
    // 포스터 이미지 뷰
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 제목 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.bold16
        return label
    }()
    
    // 재생 버튼
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.playCircle, for: .normal)
        button.tintColor = Colors.primaryColor
        return button
    }()
    
    // 삭제 버튼
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.delete, for: .normal)
        button.tintColor = .red
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
        contentView.addSubview(deleteButton)
        
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    // 셀 구성
    func configure(with film: MyFilm) {
        titleLabel.text = film.title
        
        // 포스터 URL 생성 (Picsum 사용)
        let posterUrl = "https://picsum.photos/200/300?random=\(film.id)"
        if let url = URL(string: posterUrl) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "film"))
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }
}
