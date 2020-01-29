//
//  ProfileHeader.swift
//  Poster
//
//  Created by Lukáš Litvan on 26/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase

class ProfileHeader: UICollectionReusableView {
    
    static let profileHeaderId = "ProfileHeader"
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            self.descriptionLabel.text = user.description
        }
    }
    
    var descriptionTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.white
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
        configureDescriptionTitleLabel()
        configureDescriptionLabel()
    }
    
    func configureDescriptionTitleLabel() {
        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.numberOfLines = 1
        descriptionTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        descriptionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        descriptionTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
