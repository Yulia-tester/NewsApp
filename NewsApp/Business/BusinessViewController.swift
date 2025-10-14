//
//  BusinessViewController.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-05-11.
//

import UIKit
import SnapKit

class BusinessViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 20,
                                           bottom: 20,
                                           right: 20)
        // layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Properties
    private let viewModel = BusinessViewModel() // сделал let — ViewModel обычно не пересоздают

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
        
        collectionView.register(GeneralCollectionViewCell.self,
                                forCellWithReuseIdentifier: "GeneralCollectionViewCell")
        collectionView.register(DetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: "DetailsCollectionViewCell")
    }
    
    // MARK: - Methods
    private func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.reloadCell = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        viewModel.showError = { error in
            // TODO: show alert with error
            print("❗️Error:", error)
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BusinessViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let article = viewModel.articles[indexPath.section].items[indexPath.row] as? ArticleCellViewModel else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralCollectionViewCell",
                                                                for: indexPath) as? GeneralCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.set(article: article)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell",
                                                                for: indexPath) as? DetailsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.set(article: article)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension BusinessViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let article = viewModel.articles[indexPath.section].items[indexPath.row] as? ArticleCellViewModel else { return }
        navigationController?.pushViewController(NewsViewController(viewModel: NewsViewModel(article: article)),
                                                 animated: true)
        
        func collectionView(_ collectionView: UICollectionView,
                            willDisplay cell: UICollectionViewCell,
                            forItem indexPath: IndexPath) {
            if indexPath.row == (viewModel.articles[1].items.count - 15) {
                viewModel.loadData()
            }
        }
        
    

    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BusinessViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40 // учитываем sectionInset
        let firstSectionItemSize = CGSize(width: width, height: width)
        let secondSectionItemSize = CGSize(width: width, height: 100)
        return indexPath.section == 0 ? firstSectionItemSize : secondSectionItemSize
    }
}
