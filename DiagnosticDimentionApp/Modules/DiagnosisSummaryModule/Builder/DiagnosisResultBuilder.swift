// DiagnosisResultBuilder.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// Protocol for building the diagnosis result module.
protocol DiagnosisResultBuilderProtocol {
    func configureModule(probability: Double, diagnosis: String, coordinator: DiagnosisSummaryCoordinatorProtocol)
        -> UIViewController
}

/// Builder for creating the diagnosis result screen.
final class DiagnosisResultBuilder: DiagnosisResultBuilderProtocol {
    // MARK: - Module Configuration

    func configureModule(
        probability: Double,
        diagnosis: String,
        coordinator: DiagnosisSummaryCoordinatorProtocol
    ) -> UIViewController {
        let viewModel = DiagnosisResultViewModel(probability: probability, diagnosis: diagnosis)
        let resultVC = DiagnosisSummaryViewController(viewModel: viewModel, coordinator: coordinator)
        return resultVC
    }
}
