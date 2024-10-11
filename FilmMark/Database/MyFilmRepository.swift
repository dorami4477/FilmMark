//
//  MyFilmRepository.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import Foundation
import RealmSwift

final class MyFilmRepository {
    private init() { }
    static let shared = MyFilmRepository()
    private let realm = try! Realm()
    
    // realm 경로 출력
    func readURL() {
        print(realm.configuration.fileURL)
    }
    
    // 모든 데이터 읽어오기
    func readAllMyFilms() -> Results<MyFilm> {
        return realm.objects(MyFilm.self)
    }
    
    // 데이터 저장
    func createMyFilm(_ item: MyFilm) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("create realm data failed")
        }
    }
    
    // 이미 저장된 데이터인지 여부 확인 
    func isContainsFilm(_ id: Int) -> Bool {
        return readAllMyFilms().map{ $0.id }.contains(id)
    }
}
