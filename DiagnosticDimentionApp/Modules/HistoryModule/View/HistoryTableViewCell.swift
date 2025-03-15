// HistoryTableViewCell.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// A table view cell that displays a diagnosis record.
final class HistoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HistoryTableViewCell"

    // MARK: - UI Elements

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .historyCell
        view.layer.cornerRadius = 14
        return view
    }()

    private let patientNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let probabilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let diagnosisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .historyBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        containerView.addSubview(patientNameLabel)
        containerView.addSubview(probabilityLabel)
        containerView.addSubview(diagnosisLabel)
        containerView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            patientNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            patientNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            patientNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            probabilityLabel.topAnchor.constraint(equalTo: patientNameLabel.bottomAnchor, constant: 8),
            probabilityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            probabilityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            diagnosisLabel.topAnchor.constraint(equalTo: probabilityLabel.bottomAnchor, constant: 8),
            diagnosisLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            diagnosisLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: diagnosisLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration

    func configure(with record: DiagnosisRecord) {
        patientNameLabel.text = record.patientName
        probabilityLabel.text = HistoryConstants
            .probabilityMessagePrefix + String(Int(record.probability)) + HistoryConstants.percentSymbol
        diagnosisLabel.text = HistoryConstants.diagnosisMessagePrefix + String(record.diagnosis)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: record.date)
    }
}
