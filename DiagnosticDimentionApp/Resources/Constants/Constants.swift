// Constants.swift
// Copyright © KadyrKZ. All rights reserved.

import CoreGraphics
import Foundation

/// Constants for navigation bar and tab bar item titles.
enum ConstantsNavBar {
    static let diagnosticsTitle = "Diagnostics".localized()
    static let historyTitle = "History".localized()
    static let trainingTitle = "Training".localized()
}

/// DiagnosisSummaryConstants – локализованные строки для экрана результатов диагностики.
enum DiagnosisSummaryConstants {
    static var viewTitle: String { "Diagnosis Summary".localized() }
    static var nameTextFieldPlaceholder: String { "Enter name to save result".localized() }
    static var warningLabelText: String { "The result may be inaccurate.".localized() }
    static var saveButtonTitle: String { "Save".localized() }
    static var alertTitle: String { "Success".localized() }
    static var alertMessage: String { "Diagnosis saved!".localized() }
    static var alertActionTitle: String { "OK".localized() }
}

/// UserDefaults Keys
enum UserDefaultsKeys {
    static let hasShownOnboarding = "hasShownOnboarding"
}

/// LoadingConstants – локализованные строки для экрана загрузки.
enum LoadingConstants {
    static var message: String { "loadingMessageKey".localized() }
    static var hideButtonTitle: String { "Hide".localized() }
}

/// DiagnosticResponseKeys
enum DiagnosticResponseKeys {
    static let probability = "probability"
    static let diagnosis = "diagnosis"
}

/// DiagnosticConstants – локализованные строки для экрана диагностики.
enum DiagnosticConstants {
    static var diagnosticTitle: String { "MindShield".localized() }
    static var instructionsText: String {
        "instructions_text_key".localized()
    }

    static var uploadErrorAlertTitle: String { "Upload Error".localized() }
    static var unknownDiagnosis: String { "Unknown".localized() }

    static var recordButtonTitle: String { "Record Video".localized() }
    static var galleryButtonTitle: String { "Select Video from Gallery".localized() }
    static var settingsButtonTitle: String { "Settings".localized() }
    static var instructionVideoButtonTitle: String { "Watch Instruction Video".localized() }
    static var cameraUnavailableTitle: String { "Camera Unavailable".localized() }
    static var cameraUnavailableMessage: String { "This device does not support video recording.".localized() }
    static var videoRecordingUnavailableTitle: String { "Video Recording Unavailable".localized() }
    static var videoRecordingUnavailableMessage: String {
        "Video recording is not available on this device.".localized()
    }

    static var galleryUnavailableTitle: String { "Gallery Unavailable".localized() }
    static var galleryUnavailableMessage: String { "Access to the gallery is not available.".localized() }
    static var diagnosisTypes: [String] {
        ["Gait".localized(), "Hand".localized()]
    }

    static var handServerURL: String { "https://neuroalz-api-719509516996.us-central1.run.app/predict" }
    static var gaitServerURL: String { "https://my-flask-app-608127581259.us-central1.run.app/predict" }
    static var startingUploadMessage: String { "Starting video upload: ".localized() }
    static var uploadSuccessMessage: String { "Video upload successful. Server response: ".localized() }
    static var uploadErrorMessage: String { "Video upload error: ".localized() }

    static var ok: String { "OK".localized() }
}

/// SettingsConstants – локализованные строки для экрана настроек.
enum SettingsConstants {
    static var languageTitle: String { "Chose system language".localized() }
    static var themeTitle: String { "System theme".localized() }
    static let languageItems = ["Kazakh", "Russian", "English"]
    static let languageCodes = ["kk", "ru", "en"]
    static let themeItems = ["Light", "Dark"]
    static var doneButtonTitle: String { "Done".localized() }

    static let selectedLanguageKey = "selectedLanguageIndex"
    static let selectedThemeKey = "selectedThemeIndex"
}

/// HistoryConstants – локализованные строки для экрана истории.
enum HistoryConstants {
    static var clearButtonTitle: String { "Clear".localized() }
    static var probabilityPrefix: String { "Probability: ".localized() }
    static var diagnosisPrefix: String { "Diagnosis: ".localized() }
    static var probabilityMessagePrefix: String { "Probability of Parkinson's: ".localized() }
    static var diagnosisMessagePrefix: String { "Diagnosis show as: ".localized() }
    static let percentSymbol = "%"
}

/// OnboardingConstants – локализованные строки для экрана онбординга.
enum OnboardingConstants {
    static var welcomeTitle: String { "Welcome to Cognitive Diagnostics".localized() }
    static var descriptionText: String {
        "MeetingText".localized()
    }

    static var instructionsText: String {
        """
        Instructions:
        1. Tap "Record Video" to record.
        2. Follow recommendations (lighting, angle).
        3. Wait for diagnosis results.
        """.localized()
    }

    static var disclaimerText: String {
        """
        Disclaimer: This app does not replace a doctor's consultation.
        The results are preliminary and for informational purposes only.
        """.localized()
    }

    static var continueButtonTitle: String { "Start".localized() }
}

/// InstructionVideoConstants
enum InstructionVideoConstants {
    static let fileName = "instructionVideo"
    static let fileExtension = "mp4"
    static var errorTitle: String { "Error".localized() }
    static var errorMessage: String { "Instruction video not found.".localized() }
}

/// TrainingDetailConstants – константы для экрана деталей тренировки.
enum TrainingDetailConstants {
    static let videoHeight: CGFloat = 300
    static let sidePadding: CGFloat = 16
}

/// TrainingConstants – локализованные строки для экрана тренировки.import Foundation
enum TrainingConstants {
    static var title: String { "training_title_key".localized() }
    static var collectionSpacing: CGFloat = 12
    static var headerHeight: CGFloat = 40
    static let collectionCellSpacing: CGFloat = 12

    // Ключи для заголовков секций
    static var forBrainKey: String { "for_brain_key" }
    static var forFineMotorSkillsKey: String { "for_fine_motor_skills_key" }
    static var forBodyKey: String { "for_body_key" }

    // Ключи для тренировок в секции "For Brain"
    static var trainingMindTitleKey: String { "training_mind_title_key" }
    static var mindTrainDescriptionKey: String { "mind_train_description_key" }

    // Ключи для секции "For Fine Motor Skills"
    static var prayerStretchTitleKey: String { "prayer_stretch_title_key" }
    static var prayerStretchDescriptionKey: String { "prayer_stretch_description_key" }

    static var openHandSpreadsTitleKey: String { "open_hand_spreads_title_key" }
    static var openHandSpreadsDescriptionKey: String { "open_hand_spreads_description_key" }

    static var fingerFlippingTitleKey: String { "finger_flipping_title_key" }
    static var fingerFlippingDescriptionKey: String { "finger_flipping_description_key" }

    // Ключи для секции "For Body"
    static var trainingWalkingBodyTitleKey: String { "training_walking_body_title_key" }
    static var trainingWalkingBodyDescriptionKey: String { "training_walking_body_description_key" }
}

/// ImageNameConstraints
enum ImageNameConstraints {
    static let backButton: String = "backButton"
    static let background: String = "background"
    static let logo: String = "logo"
    static let gear: String = "gear"
}

/// ProbabilityDescriptionConstants
enum ProbabilityDescriptionConstants {
    static var veryLow: String { "Very Low".localized() }
    static var low: String { "Low".localized() }
    static var middle: String { "Middle".localized() }
    static var high: String { "High".localized() }
    static var veryHigh: String { "Very High".localized() }
    static var percentSymbol: String { "%" }
}
