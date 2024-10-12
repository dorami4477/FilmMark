//
//  UIViewController + Extension.swift
//  FilmMark
//
//  Created by 박다현 on 10/12/24.
//

import UIKit
import Kingfisher

extension UIViewController {
    func presentLikeAlert(_ item: MyFilm, backdropImage: UIImage, posterImage: UIImage) {
        let alertVC = LikeAlertViewController(content: item, backdropImage: backdropImage, posterImage: posterImage)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func stringToUIImage(_ urlStrings: [String], completion: @escaping ([UIImage?]) -> Void) {
        var images: [UIImage?] = Array(repeating: nil, count: urlStrings.count)
        let dispatchGroup = DispatchGroup()
        
        urlStrings.enumerated().forEach { index, urlString in
            if let url = URL(string: urlString) {
                dispatchGroup.enter()
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            images[index] = value.image
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                        DispatchQueue.main.async {
                            images[index] = nil
                        }
                    }
                    dispatchGroup.leave()
                }
            } else {
                images[index] = nil
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }

}
