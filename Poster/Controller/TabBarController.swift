//
//  ViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 19/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class TabBarController: UITabBarController {

    let newPostViewController = NewPostViewController()
    let listViewController = ListViewController()
    let mapViewController = MapViewController()
    let profileViewController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    override func loadView() {
        super.loadView()
        
        fetchUser(userId: Auth.auth().currentUser!.uid)
        
        delegate = self
        
        configureNewPostViewController()
        configureListViewController()
        configureMapViewController()
        configureProfileViewController()
        
        let listNavigationController = UINavigationController(rootViewController: listViewController)
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [newPostViewController, listNavigationController, mapNavigationController, profileNavigationController]
        selectedIndex = 1
    }

    func configureNewPostViewController() {
        newPostViewController.tabBarItem.title = "New Post"
        newPostViewController.tabBarItem.image = UIImage(systemName: "plus.app")
        newPostViewController.tabBarItem.selectedImage = UIImage(systemName: "plus.app.fill")
    }
    
    func configureListViewController() {
        listViewController.tabBarItem.title = "List"
        listViewController.tabBarItem.image = UIImage(systemName: "square.stack.3d.up")
        listViewController.tabBarItem.selectedImage = UIImage(systemName: "square.stack.3d.up.fill")
        listViewController.view.backgroundColor = Colors.white
        listViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        listViewController.navigationItem.title = "Posts"
    }
    
    func configureMapViewController() {
        mapViewController.tabBarItem.title = "Map"
        mapViewController.tabBarItem.image = UIImage(systemName: "map")
        mapViewController.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        mapViewController.view.backgroundColor = Colors.white
        mapViewController.navigationItem.title = "Map"
        mapViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func configureProfileViewController() {
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        profileViewController.userId = Auth.auth().currentUser!.uid
        
        profileViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    func fetchUser(userId: String) {
        Database.database().reference(withPath: "users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            do {
                let user = try FirebaseDecoder().decode(User.self, from: snapshot.value!)
                self.profileViewController.userId = user.id
                self.profileViewController.username = user.name
                self.profileViewController.userDescription = user.description
                self.profileViewController.navigationItem.title = user.name
            } catch let error {
                print(error)
            }
        })
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewPostViewController {
            let newPostViewController = NewPostViewController()
            newPostViewController.view.backgroundColor = Colors.white
            present(newPostViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
