// SettingsViewController.swift
// Copyright © KadyrKZ. All rights reserved.

import Localize_Swift
import UIKit

/// Protocol for handling settings flow events.
protocol SettingsCoordinatorProtocol: AnyObject {
    func didFinishSettings()
}

/// A view controller that manages system settings such as language and theme.
final class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinatorProtocol?

    // MARK: - UI Elements

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = SettingsConstants.languageTitle
        label.font = UIFont(name: "InriaSans-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var languageSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: SettingsConstants.languageItems)
        guard let savedLanguage = UserDefaults.standard.string(forKey: SettingsConstants.selectedLanguageKey),
              let index = SettingsConstants.languageCodes.firstIndex(of: savedLanguage)
        else {
            control.selectedSegmentIndex = 0
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
        }
        control.selectedSegmentIndex = index
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = SettingsConstants.themeTitle
        label.font = UIFont(name: "InriaSans-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let themeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: SettingsConstants.themeItems)
        control.selectedSegmentIndex = UserDefaults.standard.integer(forKey: SettingsConstants.selectedThemeKey)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(SettingsConstants.doneButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: "InriaSans-Bold", size: 16)
        button.backgroundColor = UIColor(named: "buttonColor")
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .button

        if let savedLanguage = UserDefaults.standard.string(forKey: SettingsConstants.selectedLanguageKey) {
            Localize.setCurrentLanguage(savedLanguage)
        }

        setupUI()
        setupConstraints()
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocalizedStrings),
            name: NSNotification.Name(LCLLanguageChangeNotification),
            object: nil
        )
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(languageLabel)
        view.addSubview(languageSegmentedControl)
        view.addSubview(themeLabel)
        view.addSubview(themeSegmentedControl)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {
        setupLanguageLabelConstraints()
        setupLanguageSegmentedControlConstraints()
        setupThemeLabelConstraints()
        setupThemeSegmentedControlConstraints()
        setupDoneButtonConstraints()
    }

    private func setupLanguageLabelConstraints() {
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupLanguageSegmentedControlConstraints() {
        NSLayoutConstraint.activate([
            languageSegmentedControl.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 20),
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languageSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupThemeLabelConstraints() {
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: languageSegmentedControl.bottomAnchor, constant: 20),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupThemeSegmentedControlConstraints() {
        NSLayoutConstraint.activate([
            themeSegmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20),
            themeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupDoneButtonConstraints() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: 40),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            doneButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    // MARK: - Actions

    @objc private func languageChanged() {
        let selectedIndex = languageSegmentedControl.selectedSegmentIndex
        let languageCodes = SettingsConstants.languageCodes
        let selectedLanguageCode = languageCodes[selectedIndex]

        UserDefaults.standard.set(selectedLanguageCode, forKey: SettingsConstants.selectedLanguageKey)
        LocalizationService.shared.setLanguage(selectedLanguageCode)
    }

    @objc private func updateLocalizedStrings() {
        languageLabel.text = SettingsConstants.languageTitle
        themeLabel.text = SettingsConstants.themeTitle
        doneButton.setTitle(SettingsConstants.doneButtonTitle, for: .normal)
    }

    @objc private func themeChanged() {
        let selectedIndex = themeSegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: SettingsConstants.selectedThemeKey)

        if let windowScene = view.window?.windowScene, let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = (selectedIndex == 0) ? .light : .dark
        }
    }

    @objc private func doneTapped() {
        coordinator?.didFinishSettings()
        dismiss(animated: true, completion: nil)
    }
}
