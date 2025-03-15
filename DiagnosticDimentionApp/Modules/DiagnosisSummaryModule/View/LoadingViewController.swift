// LoadingViewController.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// A view controller that displays a loading screen with an activity indicator, message, and a hide button.
final class LoadingViewController: UIViewController {
    // MARK: - UI Elements

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = LoadingConstants.message
        label.font = .notoSans(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var hideButton: UIButton = {
        let button = UIButton()
        button.setTitle(LoadingConstants.hideButtonTitle, for: .normal)
        button.titleLabel?.font = .notoSansBold(ofSize: 16)
        button.backgroundColor = .button
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        setupUI()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(hideButton)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            hideButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 60),
            hideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            hideButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
