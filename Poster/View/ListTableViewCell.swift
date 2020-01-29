//
//  ListTableViewCell.swift
//  Poster
//
//  Created by Lukáš Litvan on 22/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewCell: UITableViewCell {
    
    static let cellId = "ListTableViewCell"
    
    var thumbnailImageView = UIImageView()
    var descriptionLabel = UILabel()
    var dateLabel = UILabel()
    var ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(thumbnailImageView)
        addSubview(descriptionLabel)
        addSubview(ratingLabel)
        addSubview(dateLabel)
        configureThumbnailImageView()
        configureRatingLabel()
        configureDescriptionLabel()
        configureDateLabel()
    }
    
    func configureThumbnailImageView() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.numberOfLines = 1
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -12).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
    }
    
    func configureDateLabel() {
        dateLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = Colors.gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -12).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    func configureRatingLabel() {
        ratingLabel.numberOfLines = 0
        ratingLabel.font = UIFont.systemFont(ofSize: 20)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
