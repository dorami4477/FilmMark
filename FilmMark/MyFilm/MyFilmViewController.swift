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
        setupDummyData()
        setupTableView()
        loadFilms()
    }
    
    // 더미 데이터 설정
    private func setupDummyData() {
        // Realm에 데이터가 없을 경우에만 더미 데이터 추가
        if realm.objects(MyFilm.self).isEmpty {
            try! realm.write {
                for i in 1...20 {
                    let film = MyFilm(
                        id: i,
                        title: "영화 \(i)",
                        video: Bool.random(),
                        mediaType: ["movie", "tv"].randomElement()!,
                        overview: "이것은 영화 \(i)의 줄거리입니다.",
                        voteAverage: String(format: "%.1f", Double.random(in: 0...10))
                    )
                    realm.add(film)
                }
            }
        }
    }
    
    // Realm에서 영화 데이터 로드
    private func loadFilms() {
        films = realm.objects(MyFilm.self)
        mainView.tableView.reloadData()
    }
    
    // 테이블 뷰 설정
    private func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
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
         navigationController?.pushViewController(detailVC, animated: true)
     }
}
