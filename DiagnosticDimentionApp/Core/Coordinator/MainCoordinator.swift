// MainCoordinator.swift
// Copyright © KadyrKZ. All rights reserved.

import Localize_Swift
import RxSwift
import UIKit

/// MainCoordinator is responsible for initializing and configuring the main tab bar and its child coordinators.
final class MainCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let tabBarController: UITabBarController
    private let disposeBag = DisposeBag()

    private var diagnosticCoordinator: DiagnosticCoordinator?
    private var historyCoordinator: HistoryCoordinator?
    private var trainingCoordinator: TrainingCoordinator?

    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
        super.init()
    }

    override func start() {
        let diagnosticNavController = UINavigationController()
        let historyNavController = UINavigationController()
        let trainingNavController = UINavigationController()

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)

        // Configure Diagnostics tab
        let diagnosticImage = UIImage(systemName: "waveform.path.ecg", withConfiguration: symbolConfig)
        diagnosticNavController.tabBarItem = UITabBarItem(
            title: ConstantsNavBar.diagnosticsTitle,
            image: diagnosticImage,
            selectedImage: diagnosticImage
        )

        // Configure History tab
        let historyImage = UIImage(systemName: "clock", withConfiguration: symbolConfig)
        let historySelectedImage = UIImage(systemName: "clock.fill", withConfiguration: symbolConfig)
        historyNavController.tabBarItem = UITabBarItem(
            title: ConstantsNavBar.historyTitle,
            image: historyImage,
            selectedImage: historySelectedImage
        )

        // Configure Training tab
        let trainingImage = UIImage(systemName: "figure.mind.and.body", withConfiguration: symbolConfig)
        trainingNavController.tabBarItem = UITabBarItem(
            title: ConstantsNavBar.trainingTitle,
            image: trainingImage,
            selectedImage: trainingImage
        )

        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = .tabbarIcon

        diagnosticCoordinator = DiagnosticCoordinator(navigationController: diagnosticNavController)
        historyCoordinator = HistoryCoordinator(navigationController: historyNavController)
        trainingCoordinator = TrainingCoordinator(navigationController: trainingNavController)

        diagnosticCoordinator?.start()
        historyCoordinator?.start()
        trainingCoordinator?.start()

        tabBarController.viewControllers = [diagnosticNavController, historyNavController, trainingNavController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        LocalizationService.shared.currentLanguage
            .asObservable()
            .subscribe(onNext: { _ in
                diagnosticNavController.tabBarItem.title = ConstantsNavBar.diagnosticsTitle
                historyNavController.tabBarItem.title = ConstantsNavBar.historyTitle
                trainingNavController.tabBarItem.title = ConstantsNavBar.trainingTitle
            })
            .disposed(by: disposeBag)
    }
}
