//
//  TopicsPageFactoryProtocol.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 15.08.2024.
//

import UIKit

protocol TopicsPageFactoryProtocol {
  func makeTabBarItem(navigation: any Navigable)
  func makeModule() -> UIViewController
}
