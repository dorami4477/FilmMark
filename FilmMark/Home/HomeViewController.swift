//
//  HomeViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    private let mainView = HomeView()
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        mainView.moviesCollectionView.delegate = self
        mainView.moviesCollectionView.dataSource = self
        mainView.tvCollectionView.delegate = self
        mainView.tvCollectionView.dataSource = self
    }
    
    private func bind() {
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()))
        let _ = viewModel.transform(input: input)
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
