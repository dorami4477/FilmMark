//
//  MyFilmView.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit

final class MyFilmView: BaseView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 찜한 리스트"
        label.textColor = Colors.primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(MyFilmTableViewCell.self, forCellReuseIdentifier: "FilmCell")
        return tableView
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backgroundColor = .black
    }
}
