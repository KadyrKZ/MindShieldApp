// UIView+Background.swift
// Copyright © KadyrKZ. All rights reserved.

// UIView+Background.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

extension UIView {
    func setBackgroundImage(named imageName: String, contentMode: UIView.ContentMode = .scaleAspectFill) {
        let backgroundImageView = UIImageView(image: UIImage(named: imageName))
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
