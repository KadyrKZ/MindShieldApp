// DiagnosticCoordinator.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// Coordinator responsible for managing the diagnostic flow.
final class DiagnosticCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController

    // MARK: - Initialization

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    // MARK: - Flow Start

    override func start() {
        let diagnosticVC = DiagnosticBuilder().configureModule(coordinator: self)
        navigationController.viewControllers = [diagnosticVC]

        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasShownOnboarding) {
            showOnboarding()
        }
    }

    // MARK: - Navigation Methods

    func showSettings() {
        let settingsCoord = SettingsCoordinator(navigationController: navigationController)
        add(coordinator: settingsCoord)
        settingsCoord.start()
    }

    func showOnboarding() {
        let onboardingVC = OnboardingBuilder().configureModule()
        onboardingVC.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.navigationController.present(onboardingVC, animated: true) {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasShownOnboarding)
            }
        }
    }

    func showResult(percentage: CGFloat, diagnosis: String) {
        let resultCoordinator = DiagnosisResultCoordinator(navigationController: navigationController)
        add(coordinator: resultCoordinator)
        resultCoordinator.start(with: percentage, diagnosis: diagnosis)
    }
}
