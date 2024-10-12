//
//  CollectionView + Extension.swift
//  FilmMark
//
//  Created by 김정윤 on 10/12/24.
//

import UIKit

extension UICollectionView {
    // 검색결과 없을 때
    func setEmptyMessage(_ message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = Colors.primaryColor
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = Fonts.bold16
            label.sizeToFit()
            return label
        }()
        self.backgroundView = messageLabel;
    }
    
    // 검색결과 있을 때, emptyView 지우기
    func restore() {
        self.backgroundView = nil
    }
}
