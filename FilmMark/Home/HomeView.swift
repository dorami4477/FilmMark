//
//  HomeView.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    
    private let scrollView = UIScrollView()
    
    private let contentsView = UIView()
    
    private let posterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let gradientImageView = GradientImageView()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "애니메이션 가족 코메디 드라마"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let playButton = RoundRectangleButton(title: "재생",
                                          bgColor: Colors.white,
                                          textColor: Colors.black,
                                          icon: Icons.play)
    
    private let addButton = RoundRectangleButton(title: "내가 찜한 리스트",
                                         bgColor: Colors.primaryColor,
                                         textColor: Colors.white,
                                         icon: Icons.plus)
    
    private let moviesLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨는 영화"
        label.textColor = Colors.black
        label.font = Fonts.bold18
        return label
    }()
    
    private let tvLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨는 TV 시리즈"
        label.textColor = Colors.black
        label.font = Fonts.bold18
        return label
    }()
    
    let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    let tvCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.id)
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        contentsView.addSubview(posterView)
        contentsView.addSubview(moviesLabel)
        contentsView.addSubview(moviesCollectionView)
        contentsView.addSubview(tvLabel)
        contentsView.addSubview(tvCollectionView)
        
        posterView.addSubview(gradientImageView)
        posterView.addSubview(categoryLabel)
        posterView.addSubview(playButton)
        posterView.addSubview(addButton)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        posterView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(500)
        }
        
        gradientImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
        
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(addButton)
            make.height.equalTo(36)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(playButton.snp.trailing).offset(10)
            make.height.equalTo(36)
        }
        
        moviesLabel.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(moviesLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(150)
        }
        
        tvLabel.snp.makeConstraints { make in
            make.top.equalTo(moviesCollectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tvCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tvLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(150)
            make.bottom.equalTo(contentsView).inset(30)
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        gradientImageView.imageView.image = UIImage(systemName: "heart")
    }
}
