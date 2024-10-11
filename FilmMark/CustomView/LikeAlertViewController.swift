//
//  LikeAlertViewController.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LikeAlertViewController: BaseViewController {
    enum AlertMessage: String {
        case isValid = "이미 저장된 미디어에요 :)"
        case isNonValid = "미디어를 저장했어요 :)"
    }
    
    private let myFilmRepo = MyFilmRepository.shared
    private var disposeBag = DisposeBag()
    
    private let backgroundView = UIView()
    private let confirmButton = RoundRectangleButton(title: "확인", bgColor: Colors.primaryColor, textColor: Colors.white, icon: nil)
    private let messageLabel = UILabel()
    private var content = BehaviorRelay(value: MyFilm())
    
    // 저장하고 싶은 콘텐츠 받아오기 
    init(content: MyFilm) {
        super.init(nibName: nil, bundle: nil)
        self.content.accept(content)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(confirmButton)
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.15)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .clear.withAlphaComponent(0.1)
        backgroundView.backgroundColor = Colors.white
        backgroundView.layer.cornerRadius = 10
        confirmButton.titleLabel?.font = Fonts.bold15
        messageLabel.font = Fonts.bold16
    }
    
    private func bind() {
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        content
            .bind(with: self) { owner, value in
                // Realm에 저장된 상태인지에 따라 텍스트 다르게
                let isValid = owner.myFilmRepo.isContainsFilm(value.id)
                owner.messageLabel.text = isValid ? AlertMessage.isValid.rawValue : AlertMessage.isNonValid.rawValue
                // 저장되지 않은 데이터라면 Realm에 저장
                guard !isValid else { return }
                owner.myFilmRepo.createMyFilm(value)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

