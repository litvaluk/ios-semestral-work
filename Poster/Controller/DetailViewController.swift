//
//  PostViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 23/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage
import FirebaseUI

class DetailViewController: UIViewController {

    var user: User? {
        didSet {
            guard let user = user else { return }
            self.userButton.setTitle(user.name, for: .normal)
        }
    }
    
    var imageView =  UIImageView()
    var descriptionLabel = UILabel()
    var userButton = UIButton()
    var dateLabel = UILabel()
    var ratingLabel = UILabel()
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Post"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(userButton)
        
        configureScrollView()
        configureImageView()
        configureRatingLabel()
        configureDescriptionLabel()
        configureUserButton()
        configureDateLabel()
    }
    
    func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    func configureUserButton() {
        userButton.setTitleColor(.black, for: .normal)
        userButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        userButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        userButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    func configureDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: userButton.bottomAnchor, constant: 6).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func configureRatingLabel() {
        ratingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
    }
    
    func fetchUser(userId: String) {
        Database.database().reference(withPath: "users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            do {
                self.user = try FirebaseDecoder().decode(User.self, from: snapshot.value!)
            } catch let error {
                print(error)
            }
        })
    }
    
    @objc func showProfile() {
        let profile = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout(), userId: user!.id)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
}
