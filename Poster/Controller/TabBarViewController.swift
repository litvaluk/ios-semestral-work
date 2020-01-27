//
//  ViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 19/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let newPostViewController = NewPostViewController()
        newPostViewController.tabBarItem.title = "New Post"
        newPostViewController.tabBarItem.image = UIImage(systemName: "plus.app")
        newPostViewController.tabBarItem.selectedImage = UIImage(systemName: "plus.app.fill")
        
        let listViewController = ListViewController()
        listViewController.tabBarItem.title = "List"
        listViewController.tabBarItem.image = UIImage(systemName: "square.stack.3d.up")
        listViewController.tabBarItem.selectedImage = UIImage(systemName: "square.stack.3d.up.fill")
        
        let mapViewController = MapViewController()
        mapViewController.tabBarItem.title = "Map"
        mapViewController.tabBarItem.image = UIImage(systemName: "map")
        mapViewController.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        let profileViewController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout(), userId: "1")
        profileViewController.navigationItem.title = "litvanius"
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        let listNavigationController = UINavigationController(rootViewController: listViewController)
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        listNavigationController.navigationBar.tintColor = .black
        mapNavigationController.navigationBar.tintColor = .black
        profileNavigationController.navigationBar.tintColor = .black
        
        viewControllers = [newPostViewController, listNavigationController, mapNavigationController, profileNavigationController]
        selectedIndex = 1
    }

}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewPostViewController {
            print("new post clicked")
            let newPostViewController = NewPostViewController()
            present(newPostViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
