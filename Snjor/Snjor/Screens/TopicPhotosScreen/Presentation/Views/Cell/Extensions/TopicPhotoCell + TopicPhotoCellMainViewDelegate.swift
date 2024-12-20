//
//  TopicPhotoCell + TopicPhotoCellMainViewDelegate.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 17.08.2024.
//

extension TopicPhotoCell: MainPhotoCellViewDelegate {
  func downloadTapped() {
    guard let delegate = delegate else { return }
    delegate.downloadTapped(self)
  }
}
