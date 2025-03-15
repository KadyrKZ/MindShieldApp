// LocalizationService.swift
// Copyright © KadyrKZ. All rights reserved.

import Localize_Swift
import RxCocoa
import RxSwift

/// Protocol for the localization service.
protocol LocalizationServiceProtocol {
    /// BehaviorRelay that emits текущий язык приложения.
    var currentLanguage: BehaviorRelay<String> { get }

    /// Sets the current language.
    /// - Parameter language: Код языка (например, "en", "ru", "kk").
    func setLanguage(_ language: String)
}

final class LocalizationService: LocalizationServiceProtocol {
    static let shared = LocalizationService()

    let currentLanguage: BehaviorRelay<String>

    private init() {
        // Определяем начальный язык через Localize_Swift.
        let initialLanguage = Localize.currentLanguage()
        currentLanguage = BehaviorRelay(value: initialLanguage)
    }

    /// Изменяет текущий язык и уведомляет подписчиков.
    func setLanguage(_ language: String) {
        Localize.setCurrentLanguage(language)
        currentLanguage.accept(language)
    }
}
