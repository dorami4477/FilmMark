//
//  SectionOfData.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import Foundation
import RxDataSources

struct SectionOfData<Item> {
    var header: String
    var items: [Item]
}

extension SectionOfData: SectionModelType {
    init(original: SectionOfData<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}

