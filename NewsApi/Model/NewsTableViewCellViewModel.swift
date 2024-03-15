//
//  NewsTableViewCellViewModel.swift
//  NewsApi
//
//  Created by Тимур Мурадов on 15.03.2024.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    //var image: UIImage?
    
    init(title: String,
         subtitle: String,
         imageURL: URL?,
         imageData: Data? = nil)
         //image: UIImage?)
    {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
        //self.image = image
    }
}
