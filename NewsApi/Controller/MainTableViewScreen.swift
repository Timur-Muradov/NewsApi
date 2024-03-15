//
//  ViewController.swift
//  NewsApi
//
//  Created by Тимур Мурадов on 05.03.2024.
//

import UIKit
import SnapKit
import SafariServices

class MainTableViewScreen: UIViewController {
    
    private var tableView = UITableView()
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewMakeConstrains()
        apiCalled()
    }
    
    func tableViewMakeConstrains() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func apiCalled() {
        ServiceApi.shared.getData() { [ weak self ] result in
            switch result {
            case.success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}

extension MainTableViewScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell {
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

extension MainTableViewScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

