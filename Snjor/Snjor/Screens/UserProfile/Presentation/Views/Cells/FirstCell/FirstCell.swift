//
//  FirstCell.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 12.09.2024.
//

import UIKit

final class FirstCell: UICollectionViewCell {
  // MARK: Internal Properties
  var userLikedPhotosSections: [UserLikedPhotosSection] = []
  var userLikedPhotosDataSource: UserLikedPhotosDataSource?
  var userLikedPhotosViewModel: (any ContentManagingProtocol<Photo>)?
  weak var delegate: (any FirstCellDelegate)?
  
  // MARK: Views
  private let userLikedPhotosCollectionView: UserLikedPhotosCollectionView = {
    $0.backgroundColor = .black
    return $0
  }(UserLikedPhotosCollectionView())
  
  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayout()
    createPhotosDataSource(for: userLikedPhotosCollectionView)
    setupCollectionViewDelegate()
  }
  
  required init?(coder: NSCoder) {
    fatalError(.requiredInitFatalErrorText)
  }
  
  // MARK: Internal Methods
  func configure(with viewModel: any ContentManagingProtocol<Photo>) {
    self.userLikedPhotosViewModel = viewModel
    applyPhotosSnapshot()
  }
  
  // MARK: Private Methods
  private func setupViews() {
    contentView.addSubview(userLikedPhotosCollectionView)
    userLikedPhotosCollectionView.frame = contentView.bounds
  }
  
  private func setupLayout() {
    let cascadeLayout = UserProfileCascadeLayout(with: self)
    userLikedPhotosCollectionView.collectionViewLayout = cascadeLayout
  }
  
  private func setupCollectionViewDelegate() {
    userLikedPhotosCollectionView.userLikedPhotosCollectionViewDelegate = self
  }
}
