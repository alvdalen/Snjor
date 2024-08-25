//
//  SearchScreenCoordinator.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 07.08.2024.
//

import UIKit

final class SearchScreenCoordinator: Coordinatable {
  // MARK: - Internal Properties
  var navigation: any Navigable
  var childCoordinators: [any Coordinatable] = []
  
  // MARK: - Private Properties
  private let factory: any SearchScreenFactoryProtocol
  
  // MARK: - Initializers
  init(
    factory: any SearchScreenFactoryProtocol,
    navigation: any Navigable
  ) {
    self.factory = factory
    self.navigation = navigation
  }
  
  // MARK: - Internal Methods
  func start() {
    let controller = factory.makeModule(delegate: self)
//    factory.makeTabBarItem(navigation: navigation)
    navigation.navigationBar.prefersLargeTitles = true
    navigation.pushViewController(controller, animated: true)
    
  }
}

extension SearchScreenCoordinator: SearchScreenViewControllerDelegate {
  func photoCellDidSelect(_ photo: Photo) {
    let coordinator = factory.mekePhotoDetailCoordinator(
      photo: photo,
      navigation: navigation,
      overlordCoordinator: self
    )
    addAndStartChildCoordinator(coordinator)
  }
  
  func topicCellDidSelect(_ topic: Topic) {
    let coordinator = factory.mekeTopicPhotosCoordinator(
      topic: topic,
      navigation: navigation,
      overlordCoordinator: self
    )
    addAndStartChildCoordinator(coordinator)
  }
  
  func albumcCellDidSelect(_ album: Album) {
    let coordinator = factory.mekeAlbumPhotosCoordinator(
      album: album,
      navigation: navigation,
      overlordCoordinator: self
    )
    addAndStartChildCoordinator(coordinator)
  }
  
  func searchButtonClicked(with searchTerm: String) {
    let coordinator = factory.makeSearchResultScreenCoordinator(
      with: searchTerm,
      delegate: self
    )
    addAndStartChildCoordinator(coordinator)
    navigation.present(
      coordinator.navigation.rootViewController,
      animated: true
    )
    coordinator.navigation.dismissNavigation = { [weak self] in
      self?.removeChildCoordinator(coordinator)
    }
  }
}

// MARK: - ParentCoordinator
extension SearchScreenCoordinator: ParentCoordinator { }

extension SearchScreenCoordinator: SearchResultScreenCoordinatorDelegate {
  func didFinish(childCoordinator: any Coordinatable) {
    childCoordinator.navigation.dismissNavigation = nil
    removeChildCoordinator(childCoordinator)
    navigation.dismiss(animated: true)
  }
}
