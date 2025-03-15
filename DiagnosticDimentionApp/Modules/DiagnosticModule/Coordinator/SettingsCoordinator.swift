// SettingsCoordinator.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// Coordinator responsible for managing the settings flow.
final class SettingsCoordinator: BaseCoordinator, SettingsCoordinatorProtocol {
    // MARK: - Properties

    private let navigationController: UINavigationController

    // MARK: - Initialization

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    // MARK: - Flow Start

    override func start() {
        let settingsVC = SettingsViewController()
        settingsVC.coordinator = self
        settingsVC.modalPresentationStyle = .overFullScreen
        navigationController.present(settingsVC, animated: true)
    }

    // MARK: - SettingsCoordinatorProtocol

    func didFinishSettings() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
