//
//  DetailsCollectionViewCell.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-05-29.
//

import UIKit
import SnapKit

final class DetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - GUI Variables
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "image")
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Title here"
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Description for the news should be here. Please, remove this mock text"
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.frame.height)
            make.top.leading.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
    }
}
