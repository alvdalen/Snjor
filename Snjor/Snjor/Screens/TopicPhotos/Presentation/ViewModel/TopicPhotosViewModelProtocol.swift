//
//  TopicPhotosViewModelProtocol.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 17.08.2024.
//

protocol TopicPhotosViewModelProtocol: BaseViewModelProtocol {
  //  var photosCount: Int { get }
  var photos: [Photo] { get }
  func getTopicPhotoListViewModelItem(at index: Int) -> PageScreenTopicPhotosViewModelItem
  func getPhoto(at index: Int) -> Photo
  func checkAndLoadMorePhotos(at index: Int)
}
