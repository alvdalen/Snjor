//
//  BasePhotoView.swift
//  Snjor
//
//  Created by Адам on 18.07.2024.
//

import UIKit

class BasePhotoView: UIView {
  // MARK: - Properties
  var imageDownloader = ImageDownloader()
  var currentPhotoID: String?

  // MARK: - Main Photo
  let mainImageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    return $0
  }(UIImageView())

  // MARK: - Initializers
  init() {
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup Data
  /// Configure the view with a photo, url, and optional blur hash.
  /// - Parameters:
  ///   - photo: The photo object.
  ///   - url: The URL of the photo.
  ///   - blurHash: The optional blur hash of the photo.
  func configure<T>(
    with photo: T,
    url: URL?,
    blurHash: String?,
    photoID: String? = nil
  ) where T: Decodable {
    currentPhotoID = photoID
    let size = BasePhotoViewConst.blurSize
    if let blurHash = blurHash {
      mainImageView.image = UIImage(blurHash: blurHash, size: size)
      downloadImage(with: photo, url, photoID)
    } else {
      downloadImage(with: photo, url, photoID)
    }
  }

  // MARK: - Setup Views
  private func setupViews() {
    addSubview(mainImageView)
    mainImageView.fillSuperView()
  }

  // MARK: - Download Image
  /// Override this method to provide a custom sized image URL.
  /// - Parameter url: The original URL of the image.
  /// - Returns: The sized image URL.
  func sizedImageURL(from url: URL) -> URL {
    return url
  }

  private func downloadImage<T>(
    with photo: T,
    _ url: URL?,
    _ photoID: String?
  ) where T: Decodable {
    guard let url = url else { return }
    let photoURL = sizedImageURL(from: url)
    let downloadPhotoID = photoID
    imageDownloader.downloadPhoto(with: photoURL) { [weak self] (image, isCached) in
      guard let self = self,
            self.currentPhotoID == downloadPhotoID
      else { return }
      updateImage(image, isCached)
    }
  }

  private func updateImage(_ image: UIImage?, _ isCached: Bool) {
    if isCached {
      mainImageView.image = image
      print(#function, "Кэш")
    } else {
      print(#function, "Интерент")
      animateImageView(mainImageView, image)
    }
  }

  private func animateImageView(_ imageView: UIImageView, _ image: UIImage?) {
    UIView.transition(
      with: self,
      duration: BasePhotoViewConst.duration,
      options: [.transitionCrossDissolve]
    ) {
      imageView.image = image
    }
  }
}
