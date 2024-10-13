//
//  MyFilmViewModel.swift
//  FilmMark
//
//  Created by hwanghye on 10/12/24.
//

import Foundation
import RealmSwift

class MyFilmViewModel {
    private let realm = try! Realm()
    private(set) var films: Results<MyFilm>?
    
    var numberOfFilms: Int {
        return films?.count ?? 0
    }
    
    func loadFilms() {
        films = realm.objects(MyFilm.self)
    }
    
    func getFilm(at index: Int) -> MyFilm? {
        return films?[index]
    }
    
    func deleteFilm(at index: Int) {
        guard let film = films?[index] else { return }
        do {
            try realm.write {
                realm.delete(film)
            }
        } catch {
            print("Error deleting film: \(error)")
        }
    }
    
    func createContent(from film: MyFilm) -> Content {
        return Content(id: film.id,
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
    }
}
