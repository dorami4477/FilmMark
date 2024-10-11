//
//  SearchTableHeaderView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit

final class SearchTableHeaderView: UITableViewHeaderFooterView {
    static let identifier: String = "SearchTableHeaderView"
    
    private let titleView = HeaderTitleView("추천 시리즈 & 영화")
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
