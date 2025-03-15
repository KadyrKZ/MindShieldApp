// DiagnosisResultViewModel.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation

/// A view model that encapsulates the diagnosis result details such as probability and description.
final class DiagnosisResultViewModel {
    // MARK: - Properties

    let probability: Double
    let diagnosis: String

    // MARK: - Initialization

    init(probability: Double, diagnosis: String) {
        self.probability = probability
        self.diagnosis = diagnosis
    }

    // MARK: - Methods

    func saveRecord(with patientName: String) {
        let trimmedName = patientName.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? DiagnosisSummaryConstants.nobodyTitle : trimmedName
        let record = DiagnosisRecord(
            patientName: finalName,
            date: Date(),
            probability: probability,
            diagnosis: diagnosis
        )
        DataManager.shared.addRecord(record)
    }
}
