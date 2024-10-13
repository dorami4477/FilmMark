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
    private var films: Results<MyFilm>?
    private let realm = try! Realm()
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadFilms() {
        films = realm.objects(MyFilm.self)
        mainView.tableView.reloadData()
    }
    
    private func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func deleteFilm(at indexPath: IndexPath) {
        guard let film = films?[indexPath.row] else { return }
        do {
            try realm.write {
                realm.delete(film)
            }
            mainView.tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Error deleting film: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyFilmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as? MyFilmTableViewCell,
              let film = films?[indexPath.row] else {
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
        
        guard let film = films?[indexPath.row] else { return }
        
        let detailVC = MediaDetailViewController()
        let content = Content(id: film.id,
                              backdropPath: nil,
                              title: film.title,
                              name: film.title,
                              overview: film.overview,
                              posterPath: nil,
                              genreIds: nil,
                              popularity: nil,
                              video: film.video,
                              releaseDate: nil,
                              voteAverage: Double(film.voteAverage),
                              voteCount: nil,
                              mediaType: film.mediaType)
        detailVC.data = content
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
            self?.deleteFilm(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
