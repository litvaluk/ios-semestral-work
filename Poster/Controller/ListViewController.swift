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
    let storage = Storage.storage()
    private weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.pin(superView: view)
        self.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observePosts()
        self.navigationItem.title = "Posts"
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
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
            if self.isInitiallyLoaded == false {
                self.tableView.reloadData()
                self.isInitiallyLoaded = true
            }
        }
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
        print(#function, indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellId, for: indexPath) as! ListTableViewCell
        let post = self.posts[indexPath.row]
        let ref = self.storage.reference(forURL: post.image_url)
        
        cell.thumbnailImageView.sd_setImage(with: ref)
        cell.descriptionLabel.text = post.description
        cell.ratingLabel.text = String(format:"%.1f", post.rating)
        
        let date = Date(timeIntervalSince1970: post.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        cell.dateLabel.text = dateFormatter.string(from: date)

        return cell
    }
    
}
