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
    
    var numberOfCells: Int { get }
    
    func getArticle(for row: Int) -> ArticleCellViewModel
}

final class GeneralViewModel: GeneralViewModelProtocol {
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - Properties
    var numberOfCells: Int {
        articles.count
    }
    private var articles: [ArticleResponceObject] = [] {
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
        let article = articles[row]
        return ArticleCellViewModel(article: article)
    }
    
    private func loadData() {
        ApiManager.getNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError?(error.localizedDescription)
                }
            }
        }
        
        //setupMockObjects()
    }
    
    private func setupMockObjects() {
        articles = [
            ArticleResponceObject(title: "First object title",
                                  description: "First object description in the mock object",
                                  urlToImage: "...",
                                  date: "04.06.2025"),
            ArticleResponceObject(title: "Second object title",
                                  description: "Second object description in the mock object",
                                  urlToImage: "...",
                                  date: "04.06.2025"),
            ArticleResponceObject(title: "Third object title",
                                  description: "Third object description in the mock object",
                                  urlToImage: "...",
                                  date: "04.06.2025"),
            ArticleResponceObject(title: "Fourth object title",
                                  description: "Fourth object description in the mock object",
                                  urlToImage: "...",
                                  date: "04.06.2025"),
            ArticleResponceObject(title: "Fifth object title",
                                  description: "Fifth object description in the mock object",
                                  urlToImage: "...",
                                  date: "04.06.2025"),
        
        ]
    }
}
