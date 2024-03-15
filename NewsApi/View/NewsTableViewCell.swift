//
//  NewsTableViewCell.swift
//  NewsApi
//
//  Created by Тимур Мурадов on 05.03.2024.
//

import SnapKit
import UIKit

class NewsTableViewCell: UITableViewCell {
    let newsImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(subtitleLabel)
    }
        
    func setupConstraints() {
        
        newsImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(120)
        }
        
        newsTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(newsImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(newsImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(newsTitleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension NewsTableViewCell {
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
            newsTitleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            
            DispatchQueue.global().async {
                if let data = viewModel.imageData {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.newsImageView.image = image
                    }
                } else if let url = viewModel.imageURL {
                    URLSession.shared.dataTask(with: url) { [ weak self ] data, response, error in
                        guard
                            let data = data,
                            error == nil,
                            let imageView = self?.newsImageView,
                            let imageData = self?.resizedImageData(for: imageView, imageData: data) else {
                            return
                        }
                        viewModel.imageData = imageData
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }.resume()
                }
            }
        }
    
    func resizedImageData(for imageView: UIImageView, imageData: Data) -> Data? {
        guard let image = UIImage(data: imageData), image.size.width > 0 else {
            return nil
        }
        var resizedImage: UIImage?
        DispatchQueue.main.sync {
            let ratio = imageView.bounds.size.width / image.size.width
            let updatedSize = CGSize(
                width: Int(image.size.width * ratio),
                height: Int(image.size.height * ratio)
            )
            let size = updatedSize
            let format = UIGraphicsImageRendererFormat(for: UITraitCollection(displayScale: 1))
            resizedImage = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
        }
        return resizedImage?.jpegData(compressionQuality: 1)
    }
}
