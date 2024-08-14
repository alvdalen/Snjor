//
//  Item.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 14.08.2024.
//

enum Item: Hashable {
  case topic(Topic)
  case album(Album)
  
  var topic: Topic? {
    switch self {
    case .topic(let topic):
      return topic
    default:
      return nil
    }
  }
  
  var album: Album? {
    if case .album(let album) = self {
      return album
    } else {
      return nil
    }
  }
  
  static var albums: [Item] = []
  static var topics: [Item] = []
}
