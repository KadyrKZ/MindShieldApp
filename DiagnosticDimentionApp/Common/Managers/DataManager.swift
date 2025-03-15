// DataManager.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation

final class DataManager {
    static let shared = DataManager()
    private init() {
        loadRecords()
    }

    private(set) var diagnosisResults: [DiagnosisRecord] = []

    private let userDefaultsKey = "diagnosisResultsKey"

    func addRecord(_ record: DiagnosisRecord) {
        diagnosisResults.append(record)
        saveRecords()
    }

    func clearRecords() {
        diagnosisResults.removeAll()
        saveRecords()
    }

    private func saveRecords() {
        do {
            let data = try JSONEncoder().encode(diagnosisResults)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to encode records: \(error)")
        }
    }

    private func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            diagnosisResults = try JSONDecoder().decode([DiagnosisRecord].self, from: data)
        } catch {
            print("Failed to decode records: \(error)")
        }
    }
}
