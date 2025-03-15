// DiagnosticViewModel.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

/// View model for diagnostic operations.
final class DiagnosticViewModel {
    private let disposeBag = DisposeBag()

    // Reactive properties for localized strings.
    let localizedDiagnosticTitle: Driver<String>
    let localizedInstructions: Driver<String>
    let localizedRecordButtonTitle: Driver<String>
    let localizedGalleryButtonTitle: Driver<String>
    let localizedInstructionVideoButtonTitle: Driver<String>
    let localizedSegmentTitles: Driver<[String]>

    // MARK: - Callbacks

    var onUploadSuccess: (([String: Any]) -> Void)?
    var onUploadFailure: ((Error) -> Void)?

    init() {
        localizedDiagnosticTitle = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.diagnosticTitle }
            .asDriver(onErrorJustReturn: DiagnosticConstants.diagnosticTitle)

        localizedInstructions = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.instructionsText }
            .asDriver(onErrorJustReturn: DiagnosticConstants.instructionsText)

        localizedRecordButtonTitle = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.recordButtonTitle }
            .asDriver(onErrorJustReturn: DiagnosticConstants.recordButtonTitle)

        localizedGalleryButtonTitle = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.galleryButtonTitle }
            .asDriver(onErrorJustReturn: DiagnosticConstants.galleryButtonTitle)

        localizedInstructionVideoButtonTitle = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.instructionVideoButtonTitle }
            .asDriver(onErrorJustReturn: DiagnosticConstants.instructionVideoButtonTitle)

        localizedSegmentTitles = LocalizationService.shared.currentLanguage
            .map { _ in DiagnosticConstants.diagnosisTypes }
            .asDriver(onErrorJustReturn: DiagnosticConstants.diagnosisTypes)
    }

    // MARK: - Methods

    func uploadVideo(videoURL: URL, serverURL: String) {
        print(DiagnosticConstants.startingUploadMessage + videoURL.absoluteString)
        APIService.shared.upload(videoURL: videoURL, to: serverURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(DiagnosticConstants.uploadSuccessMessage + "\(response)")
                    self?.onUploadSuccess?(response)
                case let .failure(error):
                    print(DiagnosticConstants.uploadErrorMessage + error.localizedDescription)
                    self?.onUploadFailure?(error)
                }
            }
        }
    }
}
