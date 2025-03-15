// DiagnosisSummaryViewController.swift
// Copyright © KadyrKZ. All rights reserved.

import UIKit

final class DiagnosisSummaryViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: DiagnosisResultViewModel
    private weak var coordinator: DiagnosisSummaryCoordinatorProtocol?

    // MARK: - UI Elements

    private lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = DiagnosisSummaryConstants.nameTextFieldPlaceholder
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = DiagnosisSummaryConstants.warningLabelText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setTitle(DiagnosisSummaryConstants.saveButtonTitle, for: .normal)
        button.titleLabel?.font = .notoSans(ofSize: 16)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 20
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    init(viewModel: DiagnosisResultViewModel, coordinator: DiagnosisSummaryCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        updateUI()
        setupKeyboardNotifications()
    }

    // MARK: - UI Setup

    private func setupView() {
        view.backgroundColor = .historyBackground
        title = DiagnosisSummaryConstants.viewTitle
        view.addSubview(circularProgressView)
        view.addSubview(nameTextField)
        view.addSubview(warningLabel)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circularProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            circularProgressView.widthAnchor.constraint(equalToConstant: 180),
            circularProgressView.heightAnchor.constraint(equalTo: circularProgressView.widthAnchor),

            nameTextField.topAnchor.constraint(equalTo: circularProgressView.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            warningLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 14),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - UI Updates

    private func updateUI() {
        circularProgressView.progress = CGFloat(viewModel.probability) / 100.0
    }

    // MARK: - Actions

    @objc private func saveButtonTapped() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.saveRecord(with: name)

        let alert = UIAlertController(
            title: DiagnosisSummaryConstants.alertTitle,
            message: DiagnosisSummaryConstants.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: DiagnosisSummaryConstants.alertActionTitle, style: .default) { _ in
            self.coordinator?.didFinishDiagnosisResult()
        })
        present(alert, animated: true)
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate

extension DiagnosisSummaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
