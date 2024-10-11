//
//  MyFilm.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import Foundation
import RealmSwift

final class MyFilm: Object {
    @Persisted(primaryKey: true) var id: Int // 콘텐츠 아이디
    @Persisted var title: String? // 제목
    @Persisted var video: Bool? // 예고편 여부
    @Persisted var mediaType: String? // 콘텐츠 유형
    @Persisted var overview: String? // 줄거리
    @Persisted var voteAverage: String // 소수점 첫째 자리까지의 별점 평균
    
    convenience init(id: Int, title: String? = nil, video: Bool? = nil, mediaType: String? = nil, overview: String? = nil, voteAverage: String) {
        self.init()
        self.id = id
        self.title = title
        self.video = video
        self.mediaType = mediaType
        self.overview = overview
        self.voteAverage = voteAverage
    }
}
