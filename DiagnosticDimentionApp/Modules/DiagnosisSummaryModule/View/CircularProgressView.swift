// CircularProgressView.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

/// A visual representation of a circular progress view that displays a percentage and a probability description.
class CircularProgressView: UIView {
    // MARK: - Properties

    private var trackLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let probabilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The progress value, clamped between 0 and 1. Setting this property updates the view.
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircularPath()
        setupLabels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircularPath()
        setupLabels()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircularPath()
    }

    // MARK: - Setup Methods

    /// Configures the circular path for the track and progress layers.
    private func setupCircularPath() {
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()

        let radius = (min(bounds.width, bounds.height) - 20) / 2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let circularPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        // Configure track layer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 12
        layer.addSublayer(trackLayer)

        // Configure progress layer
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.lineWidth = 12
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    /// Sets up the percentage and probability labels.
    private func setupLabels() {
        addSubview(percentageLabel)
        addSubview(probabilityLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            probabilityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            probabilityLabel.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 5)
        ])
    }

    // MARK: - Update Methods

    /// Updates the progress view based on the current progress value.
    private func updateProgress() {
        let clampedProgress = max(0, min(progress, 1))
        let percentage = Int(clampedProgress * 100)

        progressLayer.strokeEnd = clampedProgress
        percentageLabel.text = String(percentage) + ProbabilityDescriptionConstants.percentSymbol
        probabilityLabel.text = getProbabilityDescription(for: percentage)
        progressLayer.strokeColor = getProgressColor(for: percentage).cgColor

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = clampedProgress
        animation.duration = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnimation")
    }

    /// Returns a probability description based on the given percentage.
    private func getProbabilityDescription(for percentage: Int) -> String {
        switch percentage {
        case 0 ... 20:
            return ProbabilityDescriptionConstants.veryLow
        case 21 ... 40:
            return ProbabilityDescriptionConstants.low
        case 41 ... 60:
            return ProbabilityDescriptionConstants.middle
        case 61 ... 80:
            return ProbabilityDescriptionConstants.high
        default:
            return ProbabilityDescriptionConstants.veryHigh
        }
    }

    /// Returns a progress color based on the given percentage.
    private func getProgressColor(for percentage: Int) -> UIColor {
        switch percentage {
        case 0 ... 20:
            return .blue
        case 21 ... 40:
            return .green
        case 41 ... 60:
            return .yellow
        case 61 ... 80:
            return .orange
        default:
            return .red
        }
    }
}
