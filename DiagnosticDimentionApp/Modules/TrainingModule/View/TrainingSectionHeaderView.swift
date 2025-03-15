// TrainingSectionHeaderView.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// A reusable view that displays a section header title for training sections.
final class TrainingSectionHeaderView: UICollectionReusableView {
    // MARK: - Properties

    static let reuseIdentifier = "TrainingSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBold(ofSize: 22)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with title: String) {
        titleLabel.text = title
    }
}
