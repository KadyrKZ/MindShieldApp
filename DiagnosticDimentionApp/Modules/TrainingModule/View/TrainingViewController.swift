// TrainingViewController.swift
// Copyright © KadyrKZ. All rights reserved.

import Localize_Swift
import RxCocoa
import RxSwift
import UIKit

/// View controller for displaying training items.
final class TrainingViewController: UIViewController {
    // MARK: - Properties

    var viewModel: TrainingViewModel!
    weak var coordinator: (TrainingCoordinatorProtocol & AnyObject)?

    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()

    /// Local variable for storing the static training sections.
    private var sections: [TrainingSection] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupCollectionView()

        // Subscribe to reactive updates for the screen title.
        viewModel.localizedTitle
            .drive(onNext: { [weak self] newTitle in
                self?.title = newTitle
            })
            .disposed(by: disposeBag)

        // Subscribe to changes in section titles to trigger a reload of the collection view.
        viewModel.localizedSectionTitles
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        // Initialize static training sections.
        sections = viewModel.getTrainingSections()
    }

    // MARK: - UI Setup

    private func setupBackgroundImage() {
        let backgroundImageView = UIImageView(image: .background)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        // Создаём стандартный FlowLayout без жёстких настроек отступов – они будут определяться делегатом.
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: TrainingConstants.headerHeight)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            TrainingCollectionViewCell.self,
            forCellWithReuseIdentifier: TrainingCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            TrainingSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrainingSectionHeaderView.reuseIdentifier
        )

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: TrainingConstants.collectionSpacing
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: TrainingConstants.collectionSpacing
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -TrainingConstants.collectionSpacing
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -TrainingConstants.collectionSpacing
            )
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension TrainingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrainingCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrainingCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = sections[indexPath.section].items[indexPath.item]
        cell.configure(with: model)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrainingSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? TrainingSectionHeaderView else {
                return UICollectionReusableView()
            }
            let localizedTitle = sections[indexPath.section].titleKey.localized()
            header.configure(with: localizedTitle)
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension TrainingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = sections[indexPath.section].items[indexPath.item]
        coordinator?.didSelectTraining(model: model)
    }
}

extension TrainingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let spacing = TrainingConstants.collectionSpacing
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        TrainingConstants.collectionSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        TrainingConstants.collectionCellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let insets = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            insetForSectionAt: indexPath.section
        )
        let interItemSpacing = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            minimumInteritemSpacingForSectionAt: indexPath.section
        )
        let availableWidth = collectionView.bounds.width - insets.left - insets.right - interItemSpacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.3)
    }
}
