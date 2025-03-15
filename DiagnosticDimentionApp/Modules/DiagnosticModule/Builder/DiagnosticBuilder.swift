// DiagnosticBuilder.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// Protocol for building a diagnostic module.
protocol DiagnosticBuilderProtocol {
    func configureModule(coordinator: DiagnosticCoordinator) -> UIViewController
}

/// Builder for configuring the diagnostic module.
final class DiagnosticBuilder: DiagnosticBuilderProtocol {
    // MARK: - Module Configuration

    func configureModule(coordinator: DiagnosticCoordinator) -> UIViewController {
        let diagnosticVC = DiagnosticViewController()
        diagnosticVC.coordinator = coordinator
        let diagnosticVM = DiagnosticViewModel()
        diagnosticVC.viewModel = diagnosticVM
        return diagnosticVC
    }
}
