//
//  SearchHeaderView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit

final class SearchCollectionHeaderView: UICollectionReusableView {
    static let identifier = "SearchHeaderView"
    
    private let titleView = HeaderTitleView("영화 & 시리즈")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        addSubview(titleView)
    }
    
    private func configureLayout() {
        titleView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
