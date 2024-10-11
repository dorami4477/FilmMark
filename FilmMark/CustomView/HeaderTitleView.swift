//
//  HeaderTitleView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit

// MARK: Header 내 TitleView 
final class HeaderTitleView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold18
        label.textColor = Colors.primaryColor
        return label
    }()
    
    init(_ title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
