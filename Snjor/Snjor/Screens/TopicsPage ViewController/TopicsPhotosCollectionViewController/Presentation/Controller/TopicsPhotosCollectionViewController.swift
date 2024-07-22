//
//  TopicsPhotosCollectionViewController.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 22.07.2024.
//

import UIKit
import Combine

protocol TopicsPhotosViewControllerDelegate: AnyObject {
  func didSelect(_ photo: Photo)
}

class TopicsPhotosCollectionViewController: UICollectionViewController {
  
  var topicID: String?
  var pageIndex: Int?
  
  // MARK: - Delegate
  private(set) weak var delegate: (any TopicsPhotosViewControllerDelegate)?
  
  // MARK: - Private Properties
  private var cancellable = Set<AnyCancellable>()
  private(set) var downloadService = DownloadService()
  private(set) var viewModel: any TopicsPhotosViewModelProtocol
  private(set) var documentsPath = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  ).first!
  
  private let gradientView: GradientView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setColors([
      GradientView.Color(
        color: UIColor(white: 0, alpha: 1.0),
        location: 0.065
      ),
      GradientView.Color(
        color: .clear,
        location: 0.15
      ),
    ])
    $0.isUserInteractionEnabled = false
    return $0
  }(GradientView())

  // MARK: - Initializers
  init(
    viewModel: any TopicsPhotosViewModelProtocol,
    delegate: any TopicsPhotosViewControllerDelegate,
    layout: UICollectionViewLayout
  ) {
    self.viewModel = viewModel
    self.delegate = delegate
    super.init(collectionViewLayout: layout)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    print(#function, "TopicsPhotosCollectionViewController")
    
        view.addSubview(gradientView)
        NSLayoutConstraint.activate([
          gradientView.topAnchor.constraint(equalTo: view.topAnchor),
          gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
          gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Private Methods
  private func setupCollectionView() {
    collectionView.register(
      TopicsPhotosCollectionViewController.self,
      forCellWithReuseIdentifier: PhotoCell.reuseID
    )
    
    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.reuseID
    )
  }
  
  private func setupDataSource() {
    viewModel.createDataSource(
      for: collectionView,
      delegate: self
    )
  }

  private func configureDownloadSession() {
    downloadService.configureSession(
      delegate: self,
      id: Self.sessionID
    )
  }

  private func stateController() {
    viewModel
      .state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        switch state {
        case .success:
          viewModel.applySnapshot()
        case .loading: break
        case .fail(error: let error):
          self.presentAlert(message: error, title: AppLocalized.error)
        }
      }
      .store(in: &cancellable)
  }
  
}
