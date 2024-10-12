//
//  SearchHeaderView.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit

final class SearchCollectionHeaderView: UICollectionReusableView {
    enum HeaderTitle: String {
        case trending = "추천 시리즈 & 영화"
        case search = "영화 & 시리즈"
    }
    static let identifier = "SearchHeaderView"

    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
    }
    
    private func configureView() {
        titleLabel.font = Fonts.bold18
        titleLabel.textColor = Colors.primaryColor
    }
    
    func configureHeader(titleCase: HeaderTitle) {
        titleLabel.text = titleCase.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
