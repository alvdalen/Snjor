//
//  AlbumCellRootView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 18.12.2024.
//

import UIKit

fileprivate typealias Const = AlbumCellConst

final class AlbumCellRootView: BaseView {
  // MARK: Views
  let mainView: AlbumCellMainView = {
    return $0
  }(AlbumCellMainView())
  
  let tagsCollectionView: AlbumTagsCollectionView = {
    $0.heightAnchor.constraint(
      equalToConstant: Const.gradientWidthSize
    ).isActive = true
    return $0
  }(AlbumTagsCollectionView())
  
  private let rightGradientView: MainGradientView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = false
    $0.widthAnchor.constraint(
      equalToConstant: Const.gradientWidthSize
    ).isActive = true
    $0.transform = CGAffineTransform(
      rotationAngle: .pi / Const.rightGradientViewRotationAngle
    )
    return $0
  }(MainGradientView())
  
  private let leftGradientView: MainGradientView = {
    $0.isUserInteractionEnabled = false
    $0.widthAnchor.constraint(
      equalToConstant: Const.gradientWidthSize
    ).isActive = true
    $0.transform = CGAffineTransform(
      rotationAngle: .pi * Const.leftGradientViewRotationAngle
    )
    return $0
  }(MainGradientView())
  
  lazy var mainViewAndTagsCollectionStackView: UIStackView = {
    $0.axis = .vertical
    $0.addArrangedSubview(mainView)
    $0.addArrangedSubview(tagsCollectionView)
    $0.spacing = Const.stackViewSpacing
    return $0
  }(UIStackView())
  
  // MARK: Initializers
  override func initViews() {
    addSubviews()
    setupConstraints()
    updateGradientColors()
  }
  
  // MARK: Setup Views
  private func addSubviews() {
    addSubview(mainViewAndTagsCollectionStackView)
    addSubview(rightGradientView)
    addSubview(leftGradientView)
  }
  
  private func setupConstraints() {
    mainViewAndTagsCollectionStackView.fillSuperView()
    setupLeftGradientViewConstraints()
    setupRightGradientViewConstraints()
  }
  
  private func setupLeftGradientViewConstraints() {
    leftGradientView.setConstraints(
      top: tagsCollectionView.topAnchor,
      bottom: tagsCollectionView.bottomAnchor,
      left: tagsCollectionView.leftAnchor
    )
  }
  
  private func setupRightGradientViewConstraints() {
    rightGradientView.setConstraints(
      top: tagsCollectionView.topAnchor,
      right: tagsCollectionView.rightAnchor,
      bottom: tagsCollectionView.bottomAnchor
    )
  }
  
  // MARK: Update Gradient Colors
  private func updateGradientColors() {
    configureGradientView(for: rightGradientView)
    configureGradientView(for: leftGradientView)
  }
  
  private func configureGradientView(for gradientView: MainGradientView) {
    let colors = createGradientColors()
    gradientView.setColors(colors)
  }
  
  private func createGradientColors() -> [MainGradientView.Color] {
    return [
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(Const.maxOpacity),
        location: Const.gradientStartLocation
      ),
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(.zero),
        location: Const.gradientEndLocation
      )
    ]
  }
  
  override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(
      comparedTo: previousTraitCollection
    ) {
      updateGradientColors()
    }
  }
}
