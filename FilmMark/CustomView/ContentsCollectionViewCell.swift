//
//  ContentsCollectionViewCell.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import SnapKit

// MARK: - common collection cell
final class ContentsCollectionViewCell: UICollectionViewCell {
    
    static let id = "ContentsCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
