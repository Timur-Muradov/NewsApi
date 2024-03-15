//
//  ImageLoader.swift
//  NewsApi
//
//  Created by Тимур Мурадов on 15.03.2024.
//

import UIKit

class ImageLoader {

    static let shared = ImageLoader()
    private var imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
