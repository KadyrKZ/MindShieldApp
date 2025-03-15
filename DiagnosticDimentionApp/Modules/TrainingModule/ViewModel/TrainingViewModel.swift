// TrainingViewModel.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

/// View model for managing training sections with dynamic localization.
final class TrainingViewModel {
    private let disposeBag = DisposeBag()

    // Статический массив тренировочных секций, создаётся один раз.
    private let staticTrainingSections: [TrainingSection] = [
        TrainingSection(titleKey: TrainingConstants.forBrainKey, items: [
            TrainingModel(
                titleKey: TrainingConstants.trainingMindTitleKey,
                imageName: "trainForMindImage",
                videoName: "trainMind.mp4",
                descriptionKey: TrainingConstants.mindTrainDescriptionKey
            )
        ]),
        TrainingSection(titleKey: TrainingConstants.forFineMotorSkillsKey, items: [
            TrainingModel(
                titleKey: TrainingConstants.prayerStretchTitleKey,
                imageName: "trainingFineImage",
                videoName: "trainingFingers.mp4",
                descriptionKey: TrainingConstants.prayerStretchDescriptionKey
            ),
            TrainingModel(
                titleKey: TrainingConstants.openHandSpreadsTitleKey,
                imageName: "trainingFineImage",
                videoName: "trainingFingers2.mp4",
                descriptionKey: TrainingConstants.openHandSpreadsDescriptionKey
            ),
            TrainingModel(
                titleKey: TrainingConstants.fingerFlippingTitleKey,
                imageName: "trainingFineImage",
                videoName: "trainingFingers3.mp4",
                descriptionKey: TrainingConstants.fingerFlippingDescriptionKey
            )
        ]),
        TrainingSection(titleKey: TrainingConstants.forBodyKey, items: [
            TrainingModel(
                titleKey: TrainingConstants.trainingWalkingBodyTitleKey,
                imageName: "trainingWalkingImage",
                videoName: "trainingwalking.mp4",
                descriptionKey: TrainingConstants.trainingWalkingBodyDescriptionKey
            )
        ])
    ]

    /// Reactive property, который эмитирует локализованные заголовки секций.
    lazy var localizedSectionTitles: Driver<[String]> = LocalizationService.shared.currentLanguage
        .map { _ in self.staticTrainingSections.map { $0.titleKey.localized() } }
        .asDriver(onErrorJustReturn: [])

    /// Reactive property для заголовка экрана.
    let localizedTitle: Driver<String>

    init() {
        localizedTitle = LocalizationService.shared.currentLanguage
            .map { _ in TrainingConstants.title }
            .asDriver(onErrorJustReturn: TrainingConstants.title)
    }

    /// Метод для получения статических тренировочных секций.
    func getTrainingSections() -> [TrainingSection] {
        staticTrainingSections
    }

    // MARK: - Methods (например, uploadVideo)

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

    // MARK: - Callbacks

    var onUploadSuccess: (([String: Any]) -> Void)?
    var onUploadFailure: ((Error) -> Void)?
}
