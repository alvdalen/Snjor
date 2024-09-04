//
//  PageScreenPhotosViewController.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 25.07.2024.
//

import UIKit
import Combine

final class PageScreenPhotosViewController: MainViewController <PageScreenPhotosRootView> {
  
  // MARK: Internal Properties
  var topicID: String?
  var pageIndex: Int?
  var dataSource: UICollectionViewDiffableDataSource<PageScreenPhotosSection, Photo>?
  
  // MARK: Private Properties
  private var cancellable = Set<AnyCancellable>()
  private(set) weak var delegate: (any PageScreenPhotosDelegate)?
  private(set) var viewModel: any ContentManagingProtocol <Photo>
  
  // MARK: Initializers
  init(
    viewModel: any ContentManagingProtocol <Photo>,
    delegate: any PageScreenPhotosDelegate,
    layout: UICollectionViewLayout
  ) {
    self.viewModel = viewModel
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print(#function, Self.self, "🟡")
  }
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configCollectionView()
    setupDataSource()
    resetPage()
    viewModel.viewDidLoad()
    stateController()
  }
  
  // MARK: Private Methods
  private func setupDataSource() {
    createDataSource(
      for: rootView.pageScreenPhotosCollectionView
    )
  }
  
  private func resetPage() {
    PrepareParameters.photosPage = .zero
  }
  
  private func stateController() {
    viewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        switch state {
        case .success:
          self.applySnapshot()
        case .loading: break
        case .fail(error: let error):
          presentAlert(message: error, title: AppLocalized.error)
        }
      }
      .store(in: &cancellable)
  }
  
  private func configCollectionView() {
    rootView.pageScreenPhotosCollectionView.delegate = self
  }
}
