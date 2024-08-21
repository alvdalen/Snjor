//
//  SearchResultPhotosViewModel.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 22.08.2024.
//

import Combine

final class SearchResultPhotosViewModel: SearchResultPhotosViewModelProtocol {
  
  func viewDidLoad() {
    print(#function, Self.self)
  }
  
  
  // MARK: - Internal Properties
  var photosCount: Int { photos.count }
  var photos: [Photo] = []
  
  // MARK: - Private Properties
  private(set) var state: PassthroughSubject<StateController, Never>
  private let loadSearchPhotosUseCase: any LoadSearchPhotosUseCaseProtocol
  private var lastPageValidationUseCase: any lastPageValidationUseCaseProtocol
  
  // MARK: - Initializers
  init(
    state: PassthroughSubject<StateController, Never>,
    loadSearchPhotosUseCase: any LoadSearchPhotosUseCaseProtocol,
    lastPageValidationUseCase: any lastPageValidationUseCaseProtocol
  ) {
    self.state = state
    self.loadSearchPhotosUseCase = loadSearchPhotosUseCase
    self.lastPageValidationUseCase = lastPageValidationUseCase
  }
  
  // MARK: - Internal Methods
  func loadSearchPhotos(with searchTerm: String) {
    state.send(.loading)
    Task {
      await loadSearchPhotosUseCase(with: searchTerm)
    }
  }
  
  func getPhoto(at index: Int) -> Photo {
    photos[index]
  }
  
  func getPhotoListViewModelItem(
    at index: Int
  ) -> SearchResultPhotosViewModelItem {
    checkAndLoadMorePhotos(at: index)
    return makePhotoListViewModelItem(at: index)
  }
  
  func checkAndLoadMorePhotos(at index: Int) {
    lastPageValidationUseCase.checkAndLoadMoreItems(
      at: index,
      actualItems: photos.count,
      action: viewDidLoad
    )
  }
  
  // MARK: - Private Methods
  private func loadSearchPhotosUseCase(with searchTerm: String) async {
    let result = await loadSearchPhotosUseCase.execute(with: searchTerm)
    updateStateUI(with: result)
  }
  
  private func updateStateUI(with result: Result<[Photo], Error>) {
    switch result {
    case .success(let photos):
      let existingPhotoIDs = self.photos.map { $0.id }
      let newPhotos = photos.filter { !existingPhotoIDs.contains($0.id) }
      lastPageValidationUseCase.updateLastPage(itemsCount: photos.count)
      self.photos.append(contentsOf: newPhotos)
      state.send(.success)
    case .failure(let error):
      state.send(.fail(error: error.localizedDescription))
    }
  }
  
  private func makePhotoListViewModelItem(at index: Int) -> SearchResultPhotosViewModelItem {
    let photo = photos[index]
    return SearchResultPhotosViewModelItem(photo: photo)
  }
}