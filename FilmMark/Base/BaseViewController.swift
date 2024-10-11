//
//  BaseViewController.swift
//  FilmMark
//
//  Created by 박다현 on 10/8/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView(){}
    
}
