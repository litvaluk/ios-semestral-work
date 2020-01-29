//
//  ProfileViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 20/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage
import FirebaseUI
import FirebaseAuth

class ProfileViewController: UICollectionViewController {

    var userId: String?
    var username: String?
    var userDescription: String?
    
    var posts: [Post] = []
    var isInitiallyLoaded = false
    
    override func loadView() {
        super.loadView()
        observePosts()
        configureCollectionView()
        
        if userId == Auth.auth().currentUser?.uid {
            addLogoutButton()
        }
    }
    
    func addLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            let initialViewController = InitialViewController()
            initialViewController.view.backgroundColor = Colors.white
            initialViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.view.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
            self.view.window?.makeKeyAndVisible()
        } catch let error {
            print(error)
        }
    }
    
    public func observePosts() {
        Database.database().reference(withPath: "posts").observe(.value) { snapshot in
            self.posts.removeAll()
            for post in snapshot.value as? [String : AnyObject] ?? [:] {
                do {
                    let post = try FirebaseDecoder().decode(Post.self, from: post.value)
                    if post.user_id == self.userId! {
                        self.posts.append(post)
                    }
                } catch let error {
                    print(error)
                }
            }
            if self.isInitiallyLoaded == false {
                self.collectionView.reloadData()
                self.isInitiallyLoaded = true
            }
        }
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = Colors.white
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.profileHeaderId)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.cellId)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
    }
    
    func getDetailViewController(post: Post) -> DetailViewController {
        let detail = DetailViewController()
        let ref = Storage.storage().reference(forURL: post.image_url)
        
        detail.view.backgroundColor = Colors.white
        detail.navigationItem.title = "Post"
        detail.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        detail.imageView.sd_setImage(with: ref)
        let height = ((detail.imageView.image?.size.height)! * detail.view.frame.width) / (detail.imageView.image?.size.width)!
        detail.imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        detail.imageView.widthAnchor.constraint(equalToConstant: detail.view.frame.width).isActive = true
        detail.descriptionLabel.text = post.description
        detail.ratingLabel.text = String(format:"%.1f", post.rating)
        detail.dateLabel.text = Utils.timestampToString(timestamp: post.timestamp)
        detail.fetchUser(userId: post.user_id)
        
        return detail
    }
    
    @objc
    private func refreshTriggered(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.reloadData()
            sender.endRefreshing()
        }
    }
}

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.profileHeaderId, for: indexPath) as! ProfileHeader
        header.descriptionLabel.text = userDescription
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.cellId, for: indexPath) as! ProfileCollectionViewCell
        let post = self.posts[indexPath.row]
        let ref = Storage.storage().reference(forURL: post.image_url)
        cell.imageView.sd_setImage(with: ref)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(getDetailViewController(post: post), animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
        print(#function, indexPath)
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
