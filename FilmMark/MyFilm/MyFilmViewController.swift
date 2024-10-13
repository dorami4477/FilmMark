//
//  MyFilmViewController.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import UIKit
import RealmSwift
import Kingfisher

final class MyFilmViewController: BaseViewController {
    private let mainView = MyFilmView()
    private let viewModel = MyFilmViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFilms()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFilms()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "내가 찜한 리스트"
    }
    
    private func loadFilms() {
        viewModel.loadFilms()
        mainView.tableView.reloadData()
    }
    
    private func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyFilmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFilms
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as? MyFilmTableViewCell,
              let film = viewModel.getFilm(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: film)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let film = viewModel.getFilm(at: indexPath.row) else { return }
        
        let detailVC = MediaDetailViewController(myFilm: film)
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
            self?.viewModel.deleteFilm(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
