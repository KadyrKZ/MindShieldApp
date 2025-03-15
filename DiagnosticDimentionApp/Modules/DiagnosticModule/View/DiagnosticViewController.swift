// DiagnosticViewController.swift
// Copyright © KadyrKZ. All rights reserved.

import AVKit
import Localize_Swift
import MobileCoreServices
import RxCocoa
import RxSwift
import UIKit
import UniformTypeIdentifiers

/// Diagnostic view controller.
class DiagnosticViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var coordinator: DiagnosticCoordinator?

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBold(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hostingSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: DiagnosticConstants.diagnosisTypes)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let recordButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 34
        button.backgroundColor = .buttonColor
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .notoSansBold(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 34
        button.backgroundColor = .buttonColor
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .notoSansBold(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let instructionVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 34
        button.backgroundColor = .buttonColor
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .notoSansBold(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let gearImage = UIImage(systemName: ImageNameConstraints.gear, withConfiguration: symbolConfig)?
            .withRenderingMode(.alwaysTemplate)
        button.setImage(gearImage, for: .normal)
        button.tintColor = .tabbarIcon
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()

    var viewModel: DiagnosticViewModel!

    // Computed property that returns the current server URL based on selected segment.
    private var currentServerURL: String {
        hostingSegmentControl.selectedSegmentIndex == 0 ?
            DiagnosticConstants.gaitServerURL :
            DiagnosticConstants.handServerURL
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupUI()
        setupConstraints()
        setupBindings()
        bindLocalization()

        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        instructionVideoButton.addTarget(self, action: #selector(instructionVideoTapped), for: .touchUpInside)

        let settingsBarButton = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsBarButton
    }

    // MARK: - Setup Methods

    private func setupUI() {
        for item in [
            titleLabel,
            instructionsLabel,
            hostingSegmentControl,
            instructionVideoButton,
            recordButton,
            galleryButton
        ] {
            view.addSubview(item)
        }
    }

    private func setupConstraints() {
        setupTitleLabelConstraints()
        setupInstructionsLabelConstraints()
        setupHostingSegmentControlConstraints()
        setupInstructionVideoButtonConstraints()
        setupRecordButtonConstraints()
        setupGalleryButtonConstraints()
    }

    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupInstructionsLabelConstraints() {
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    private func setupHostingSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            hostingSegmentControl.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 25),
            hostingSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingSegmentControl.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupInstructionVideoButtonConstraints() {
        NSLayoutConstraint.activate([
            instructionVideoButton.topAnchor.constraint(equalTo: hostingSegmentControl.bottomAnchor, constant: 30),
            instructionVideoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            instructionVideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            instructionVideoButton.heightAnchor.constraint(equalToConstant: 67)
        ])
    }

    private func setupRecordButtonConstraints() {
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: instructionVideoButton.bottomAnchor, constant: 20),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            recordButton.heightAnchor.constraint(equalToConstant: 67)
        ])
    }

    private func setupGalleryButtonConstraints() {
        NSLayoutConstraint.activate([
            galleryButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            galleryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            galleryButton.heightAnchor.constraint(equalToConstant: 67)
        ])
    }

    private func setupSettingsButtonConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupBackgroundImage() {
        view.setBackgroundImage(named: ImageNameConstraints.background)
    }

    private func setupBindings() {
        viewModel.onUploadSuccess = { [weak self] response in
            guard let self = self else { return }
            let rawProb = response[DiagnosticResponseKeys.probability] as? Double ?? 0.0
            let diagnosis = response[DiagnosticResponseKeys.diagnosis] as? String ?? DiagnosticConstants
                .unknownDiagnosis
            let percentage = CGFloat(rawProb * 100)
            self.dismiss(animated: true) {
                self.coordinator?.showResult(percentage: percentage, diagnosis: diagnosis)
            }
        }
        viewModel.onUploadFailure = { [weak self] error in
            self?.dismiss(animated: true) {
                self?.showAlert(title: DiagnosticConstants.uploadErrorMessage, message: error.localizedDescription)
            }
        }
    }

    // MARK: - RxSwift Localization Binding

    private func bindLocalization() {
        let stringBindings: [(Driver<String>, Binder<String?>)] = [
            (viewModel.localizedDiagnosticTitle, titleLabel.rx.text),
            (viewModel.localizedInstructions, instructionsLabel.rx.text),
            (viewModel.localizedRecordButtonTitle, recordButton.rx.title(for: .normal)),
            (viewModel.localizedGalleryButtonTitle, galleryButton.rx.title(for: .normal)),
            (viewModel.localizedInstructionVideoButtonTitle, instructionVideoButton.rx.title(for: .normal))
        ]

        for (driver, binder) in stringBindings {
            driver.drive(binder).disposed(by: disposeBag)
        }

        viewModel.localizedSegmentTitles
            .drive(onNext: { [weak self] titles in
                guard let self = self, titles.count >= 2 else { return }
                self.hostingSegmentControl.setTitle(titles[0], forSegmentAt: 0)
                self.hostingSegmentControl.setTitle(titles[1], forSegmentAt: 1)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @objc private func recordButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(
                title: DiagnosticConstants.cameraUnavailableTitle,
                message: DiagnosticConstants.cameraUnavailableMessage
            )
            return
        }
        guard let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera),
              availableTypes.contains(UTType.movie.identifier)
        else {
            showAlert(
                title: DiagnosticConstants.videoRecordingUnavailableTitle,
                message: DiagnosticConstants.videoRecordingUnavailableMessage
            )
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [UTType.movie.identifier]
        imagePicker.videoQuality = .typeHigh
        present(imagePicker, animated: true)
    }

    @objc private func galleryButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(
                title: DiagnosticConstants.galleryUnavailableTitle,
                message: DiagnosticConstants.galleryUnavailableMessage
            )
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [UTType.movie.identifier]
        present(imagePicker, animated: true)
    }

    @objc private func settingsTapped() {
        coordinator?.showSettings()
    }

    @objc private func instructionVideoTapped() {
        if let videoURL = Bundle.main.url(
            forResource: InstructionVideoConstants.fileName,
            withExtension: InstructionVideoConstants.fileExtension
        ) {
            let player = AVPlayer(url: videoURL)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            present(playerVC, animated: true) {
                player.play()
            }
        } else {
            showAlert(title: InstructionVideoConstants.errorTitle, message: InstructionVideoConstants.errorMessage)
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let videoURL = info[.mediaURL] as? URL {
            picker.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                let loadingVC = LoadingViewController()
                loadingVC.modalPresentationStyle = .overFullScreen
                self.present(loadingVC, animated: true) {
                    self.viewModel.uploadVideo(videoURL: videoURL, serverURL: self.currentServerURL)
                }
            }
        } else {
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: DiagnosticConstants.ok, style: .default))
        present(alertController, animated: true)
    }
}
