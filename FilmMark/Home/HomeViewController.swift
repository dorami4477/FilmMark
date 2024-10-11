//
//  HomeViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit

final class HomeViewController: BaseViewController {

    private let mainView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.moviesCollectionView.delegate = self
        mainView.moviesCollectionView.dataSource = self
        mainView.tvCollectionView.delegate = self
        mainView.tvCollectionView.dataSource = self
    }
    
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.id, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.backgroundColor = .gray
        return cell
    }
}
