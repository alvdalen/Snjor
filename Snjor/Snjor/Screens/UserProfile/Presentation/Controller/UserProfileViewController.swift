//
//  UserProfileViewController.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 10.09.2024.
//

import UIKit
import Combine

final class UserProfileViewController: MainViewController<UserProfileViewControllerRootView> {
  // MARK: Private Properties
  private var cancellable = Set<AnyCancellable>()
  private(set) var userProfileViewModel: any UserProfileViewModelProtocol
  private(set) var userLikedPhotosViewModel: any ContentManagingProtocol<Photo>
  private(set) var userPhotosViewModel: any ContentManagingProtocol<Photo>
  private(set) var userAlbumsViewModel: any ContentManagingProtocol<Album>
  private(set) weak var delegate: (any UserProfileViewControllerDelegate)?
  
  // MARK: Override Properties
  override var shouldShowTabBarOnScroll: Bool {
    return false
  }
  
  // MARK: Initializers
  init(
    userProfileViewModel: any UserProfileViewModelProtocol,
    userLikedPhotosViewModel: any ContentManagingProtocol<Photo>,
    userPhotosViewModel: any ContentManagingProtocol<Photo>,
    userAlbumsViewModel: any ContentManagingProtocol<Album>,
    delegate: any UserProfileViewControllerDelegate
  ) {
    self.userProfileViewModel = userProfileViewModel
    self.userLikedPhotosViewModel = userLikedPhotosViewModel
    self.userPhotosViewModel = userPhotosViewModel
    self.userAlbumsViewModel = userAlbumsViewModel
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError(.requiredInitFatalErrorText)
  }
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    resetPage()
    userProfileState()
    userLikedPhotosState()
    userPhotosState()
    userAlbumsState()
    initializeViewModels()
    setupCollectionViewDelegate()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationItems()
  }

  deinit {
    print(#function, Self.self, "🟤")
  }
  
  // MARK: Private Methods
  private func initializeViewModels() {
    userProfileViewModel.viewDidLoad()
    userLikedPhotosViewModel.viewDidLoad()
    userPhotosViewModel.viewDidLoad()
    userAlbumsViewModel.viewDidLoad()
  }
  
  private func setupCollectionViewDelegate() {
    rootView.horizontalCollectionView.delegate = self
    rootView.horizontalCollectionView.dataSource = self
  }
  
  private func setupNavigationItems() {
    rootView.setupBarButtonItems(
      navigationItem: navigationItem,
      navigationController: navigationController
    )
  }
  
  private func resetPage() {
    PrepareParameters.userPhotosPage = .zero
    PrepareParameters.userLikedPhotosPage = .zero
    PrepareParameters.userAlbumsPage = .zero
  }
  
  private func userProfileState() {
    userProfileViewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state) {
          self.rootView.setupData(viewModel: self.userProfileViewModel)
        }
      }
      .store(in: &cancellable)
  }
  
  private func userLikedPhotosState() {
    userLikedPhotosViewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state) {
          print(#function, Self.self)
          self.rootView.horizontalCollectionView.reloadData()
        }
      }
      .store(in: &cancellable)
  }
  
  private func userPhotosState() {
    userPhotosViewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state) {
          print(#function, Self.self)
          self.rootView.horizontalCollectionView.reloadData()
        }
      }
      .store(in: &cancellable)
  }
  
  private func userAlbumsState() {
    userAlbumsViewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state) {
          self.rootView.horizontalCollectionView.reloadData()
        }
      }
      .store(in: &cancellable)
  }
  
  private func handleState(
    _ state: StateController,
    successAction: () -> Void
  ) {
    switch state {
    case .success:
      successAction()
    case .loading: break
    case .fail(error: let error):
      presentAlert(message: error, title: AppLocalized.error)
    }
  }
}
