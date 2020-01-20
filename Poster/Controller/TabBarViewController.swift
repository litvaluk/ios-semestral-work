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
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        viewControllers = [newPostViewController, listViewController, mapViewController, profileViewController]
    }


}
