//
//  MapViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 20/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import CodableFirebase

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var mapView = MKMapView()
    var posts: [Post] = []
    var selectedAnnotation: PostAnnotation?
    
    
    override func loadView() {
        super.loadView()
        view.addSubview(mapView)
        configureMapView()
        observePosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        if let userLocation = locationManager.location?.coordinate {
            let viewSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let viewRegion = MKCoordinateRegion(center: userLocation, span: viewSpan)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func configureMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MKAnnotationView")
        mapView.delegate = self
    }
 
    public func observePosts() {
        Database.database().reference(withPath: "posts").observe(.value) { snapshot in
            self.posts.removeAll()
            for post in snapshot.value as? [String : AnyObject] ?? [:] {
                do {
                    let post = try FirebaseDecoder().decode(Post.self, from: post.value)
                    self.posts.append(post)
                    self.mapView.addAnnotation(PostAnnotation(post: post))
                } catch let error {
                    print(error)
                }
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
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? PostAnnotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let postAnnotation = annotation as? PostAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MKAnnotationView")!
            view.annotation = postAnnotation
            
            view.canShowCallout = true
            view.rightCalloutAccessoryView = getShowDetailButton()
            view.calloutOffset = CGPoint(x: 0, y: -25)
            
            let imageView = getAnnotationImageView(imageUrl: postAnnotation.post.image_url)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            return view
        }
    
        return nil
    }
    
    func getAnnotationImageView(imageUrl: String) -> UIImageView {
        let imageView = UIImageView()        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Colors.white.cgColor
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: Storage.storage().reference(forURL: imageUrl))
        return imageView
    }
    
    func getShowDetailButton() -> UIButton {
        let showDetailButton = UIButton(type: .custom)
        showDetailButton.setImage(UIImage(systemName: "chevron.right"), for: [])
        showDetailButton.tintColor = Colors.black
        showDetailButton.sizeToFit()
        showDetailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        return showDetailButton
    }
    
    @objc func showDetail() {
        self.navigationController?.pushViewController(getDetailViewController(post: self.selectedAnnotation!.post), animated: true)
    }
    
}
