// DiagnosisRecord.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation

/// DiagnosisRecord
struct DiagnosisRecord: Codable {
    let patientName: String
    let date: Date
    let probability: Double
    let diagnosis: String
}
