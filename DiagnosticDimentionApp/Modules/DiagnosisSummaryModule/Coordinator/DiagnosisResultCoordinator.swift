// DiagnosisResultCoordinator.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// A protocol for coordinating the diagnosis result flow.
protocol DiagnosisSummaryCoordinatorProtocol: AnyObject {
    func didFinishDiagnosisResult()
}

/// A coordinator that manages the diagnosis result screen.
final class DiagnosisResultCoordinator: BaseCoordinator, DiagnosisSummaryCoordinatorProtocol {
    // MARK: - Properties

    private let navigationController: UINavigationController

    // MARK: - Initialization

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    // MARK: - Methods

    func start(with probability: Double, diagnosis: String) {
        let resultVC = DiagnosisResultBuilder().configureModule(
            probability: probability,
            diagnosis: diagnosis,
            coordinator: self
        )
        navigationController.pushViewController(resultVC, animated: true)
    }

    func didFinishDiagnosisResult() {
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        }
    }
}
