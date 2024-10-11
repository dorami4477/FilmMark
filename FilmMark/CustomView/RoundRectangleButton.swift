//
//  RoundRectangleButton.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import UIKit
import SnapKit

// MARK: - common button
final class RoundRectangleButton: UIButton {
    
    init(title: String, bgColor: UIColor, textColor: UIColor, icon: UIImage?) {
        super.init(frame: .zero)
        setupButton(title: title, bgColor: bgColor, textColor: textColor, icon: icon)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton(title: String, bgColor: UIColor, textColor: UIColor, icon: UIImage?) {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = bgColor
        config.title = title
        config.baseForegroundColor = textColor
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return outgoing
        }
        
        if let icon = icon {
            config.image = icon.withRenderingMode(.alwaysTemplate)
            config.imagePadding = 8
            config.imagePlacement = .leading
        }
        
        self.configuration = config
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

}
