//
//  ServiceApi.swift
//  NewsApi
//
//  Created by Тимур Мурадов on 05.03.2024.
//

import Foundation

class ServiceApi {
    static let shared = ServiceApi()
    private let urlString = "https://newsapi.org/v2/everything?q=apple&from=2024-03-09&to=2024-03-09&sortBy=popularity&apiKey=09257ecb434a4f9297031836f674a36b"
    
    func getData(completion: @escaping (Result<[Article],Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ModelNews.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
