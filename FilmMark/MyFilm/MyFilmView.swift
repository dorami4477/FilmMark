//
//  MyFilmView.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit

final class MyFilmView: BaseView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(MyFilmTableViewCell.self, forCellReuseIdentifier: "FilmCell")
        return tableView
    }()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backgroundColor = .white
    }
}
