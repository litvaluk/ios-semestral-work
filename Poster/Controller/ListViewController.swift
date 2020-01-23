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
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.pin(superView: view)
        self.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observePosts()
        
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
