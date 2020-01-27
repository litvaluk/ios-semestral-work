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

class ProfileViewController: UICollectionViewController {

    var user: User?
    
    var userId: String?
    var storage = Storage.storage()
    var posts: [Post] = []
    var isInitiallyLoaded = false
    
    init(collectionViewLayout layout: UICollectionViewLayout, userId: String) {
        super.init(collectionViewLayout: layout)
        self.userId = userId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        observePosts()
        fetchUser(userId: userId!)
        
        configureCollectionView()
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
        collectionView.backgroundColor = .white
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.profileHeaderId)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.cellId)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
    }
    
    func getDetailViewController(post: Post) -> DetailViewController {
        let detail = DetailViewController()
        let ref = self.storage.reference(forURL: post.image_url)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.profileHeaderId, for: indexPath) as! ProfileHeader
        header.fetchUser(userId: self.userId!)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.cellId, for: indexPath) as! ProfileCollectionViewCell
        let post = self.posts[indexPath.row]
        let ref = self.storage.reference(forURL: post.image_url)
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
