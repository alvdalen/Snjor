//
//  TopicsPageViewModel.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 23.07.2024.
//

import Foundation
import Combine

final class TopicsPageViewModel: TopicsPageViewModelProtocol {

  // MARK: - Internal Properties
  var topicsCount: Int { topics.count }
  var state: PassthroughSubject<StateController, Never>
  
  // MARK: - Private Properties
  private let loadUseCase: any LoadTopicsPageUseCaseProtocol
  private var topics: [Topic] = []

  // MARK: - Initializers
  init(
    state: PassthroughSubject<StateController, Never>,
    loadUseCase: any LoadTopicsPageUseCaseProtocol
  ) {
    self.state = state
    self.loadUseCase = loadUseCase
  }

  // MARK: - Internal Methods
  func viewDidLoad() {
    state.send(.loading)
    Task {
      await loadTopicsPageUseCase()
    }
  }
  
  func getTopicsPageViewModelItem(at index: Int) -> TopicsPageViewModelItem {
    return makeViewModelItem(at: index)
  }

  // MARK: - Private Methods
  private func makeViewModelItem(at index: Int) -> TopicsPageViewModelItem {
    let topic = topics[index]
    return TopicsPageViewModelItem(topic: topic)
  }
  
  private func loadTopicsPageUseCase() async {
    let result = await loadUseCase.execute()
    updateStateUI(with: result)
  }

  private func updateStateUI(with result: Result<[Topic], Error>) {
    switch result {
    case .success(let topics):
      self.topics.append(contentsOf: topics)
      state.send(.success)
    case .failure(let error):
      state.send(.fail(error: error.localizedDescription))
    }
  }
}