//
//  ListViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 20/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import CodableFirebase

class ListViewController: UIViewController {
    
    var posts: [Post] = []
    var isInitiallyLoaded = false
    let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        configureTableView()
        observePosts()
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rowHeight = 100
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.cellId)
    }
    
    public func observePosts() {
        Database.database().reference(withPath: "posts").observe(.value) { snapshot in
            self.posts.removeAll()
            for post in snapshot.value as? [String : AnyObject] ?? [:] {
                do {
                    let post = try FirebaseDecoder().decode(Post.self, from: post.value)
                    self.posts.append(post)
                } catch let error {
                    print(error)
                }
            }
            self.posts.sort { (a, b) -> Bool in
                return a.timestamp > b.timestamp
            }
            if self.isInitiallyLoaded == false {
                self.tableView.reloadData()
                self.isInitiallyLoaded = true
            }
        }
    }
    
    // TODO
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
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(getDetailViewController(post: post), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellId, for: indexPath) as! ListTableViewCell
        let post = self.posts[indexPath.row]
        let ref = Storage.storage().reference(forURL: post.image_url)
        
        cell.thumbnailImageView.sd_setImage(with: ref)
        cell.descriptionLabel.text = post.description
        cell.ratingLabel.text = String(format:"%.1f", post.rating)
        cell.dateLabel.text = Utils.timestampToString(timestamp: post.timestamp)

        return cell
    }
    
}
