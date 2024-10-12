//
//  UIViewController + Extension.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit
import Kingfisher

extension UIViewController {
    func presentLikeAlert(_ item: MyFilm, image: UIImage) {
        let alertVC = LikeAlertViewController(content: item, image: image)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func stringToUIImage(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: urlString) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure(let error):
                    print("Error loading image: \(error)")
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
