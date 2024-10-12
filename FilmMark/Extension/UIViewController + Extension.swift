//
//  UIViewController + Extension.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit

extension UIViewController {
    func presentLikeAlert(_ item: MyFilm) {
        let alertVC = LikeAlertViewController(content: item)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true, completion: nil)
    }
}
