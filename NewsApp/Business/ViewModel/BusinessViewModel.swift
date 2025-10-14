//
//  BusinessViewModel.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-10-14.
//

import Foundation

protocol BusinessViewModelProtocol {
    var reloadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var reloadCell: ((IndexPath) -> Void)? { get set }
    var articles: [TableCollectionViewSection] { get }
    
    func loadData()
}

final class BusinessViewModel: BusinessViewModelProtocol {
    var reloadData: (() -> Void)?
    var reloadCell: ((IndexPath) -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - Properties
    private(set) var articles: [TableCollectionViewSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    
    func loadData() {
        print(#function)
        
        ApiManager.getNews { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.convertToCellViewModel(articles)
                self.loadImage()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError?(error.localizedDescription)
                }
            }
        }
        
        //setupMockObjects()
    }
    
    private func loadImage() {
        for (i, section) in articles.enumerated() {
            for (index, item) in section.items.enumerated() {
                guard let article = item as? ArticleCellViewModel else { continue }
                // если imageUrl — non-optional String, просто используем его:
                let url = article.imageUrl

                ApiManager.getImageData(url: url) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            if let article = self?.articles[i].items[index] as? ArticleCellViewModel {
                                article.imageData = data
                            }
                            self?.reloadCell?(IndexPath(row: index, section: i))
                        case .failure(let error):
                            self?.showError?(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    
    private func convertToCellViewModel(_ responses: [ArticleResponseObject]) {
        var viewModels = responses.map { ArticleCellViewModel(article: $0) }
        // безопасно обрабатывать пустой результат
        if viewModels.isEmpty {
            self.articles = []
            return
        }
        let first = TableCollectionViewSection(items: [viewModels.removeFirst()])
        let second = TableCollectionViewSection(items: viewModels)
        self.articles = [first, second]
    }
    
    private func setupMockObjects() {
        articles = [
            TableCollectionViewSection(items: [ArticleCellViewModel(article: ArticleResponseObject(title: "First object title",
                                                                                                description: "First object description in the mock object",
                                                                                                urlToImage: "...",
                                                                                                date: "04.06.2025"))])
        ]
    }
}

