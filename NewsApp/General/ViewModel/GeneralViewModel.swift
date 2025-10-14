//
//  GeneralViewModel.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-01.
//

import Foundation

protocol GeneralViewModelProtocol {
    var reloadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var reloadCell: ((Int) -> Void)? { get set }
    
    var numberOfCells: Int { get }
    
    func getArticle(for row: Int) -> ArticleCellViewModel
}

final class GeneralViewModel: GeneralViewModelProtocol {
    var reloadData: (() -> Void)?
    var reloadCell: ((Int) -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - Properties
    var numberOfCells: Int {
        articles.count
    }
    private var articles: [ArticleCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    init() {
        loadData()
    }
    
    func getArticle(for row: Int) -> ArticleCellViewModel {
        return articles[row]
    }
    
    private func loadData() {
        
        ApiManager.getNews { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.articles = self.convertToCellViewModel(articles)
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
        //        guard let url = URL(string: articles[row].imageUrl),
        //             let data = try? Data(contentsOf: url) else { return }
        
        for (index, article) in articles.enumerated() {
            ApiManager.getImageData(url: article.imageUrl) { [weak self]
                result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.articles[index].imageData = data
                        self?.reloadCell?(index)
                    case .failure(let error):
                        self?.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func convertToCellViewModel(_ articles: [ArticleResponseObject]) -> [ArticleCellViewModel] {
        return articles.map { ArticleCellViewModel(article: $0) }
    }
    
    private func setupMockObjects() {
        articles = [
            ArticleCellViewModel(article: ArticleResponseObject(title: "First object title",
                                                                description: "First object description in the mock object",
                                                                urlToImage: "...",
                                                                date: "04.06.2025"))
        ]
    }
}
