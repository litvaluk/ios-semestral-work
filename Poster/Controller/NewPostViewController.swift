//
//  NewPostViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 20/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage
import MapKit

class NewPostViewController: UIViewController {

    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let descriptionTextView = UITextView()
    let postButton = UIButton()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var leadingAnchorImageViewConstraint: NSLayoutConstraint!
    var trailingAnchorImageViewConstraint: NSLayoutConstraint!
    var heightAnchorImageViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(postButton)
        configureImageView()
        configureDescriptionLabel()
        configureDescriptionTextView()
        configurePostButton()
        
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func configureImageView() {
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        leadingAnchorImageViewConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        trailingAnchorImageViewConstraint = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        heightAnchorImageViewConstraint = imageView.heightAnchor.constraint(equalToConstant: view.frame.width - 40)
        
        leadingAnchorImageViewConstraint.isActive = true
        trailingAnchorImageViewConstraint.isActive = true
        heightAnchorImageViewConstraint.isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func configureDescriptionTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        descriptionTextView.text = "Your description"
        descriptionTextView.textColor = .gray
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.returnKeyType = .done
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func configurePostButton() {
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.backgroundColor = .black
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        postButton.clipsToBounds = true
        postButton.layer.cornerRadius = 20
        postButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
    }
    
    func shrinkImageView() {
        leadingAnchorImageViewConstraint.constant = 90
        trailingAnchorImageViewConstraint.constant = -90
        heightAnchorImageViewConstraint.constant = view.frame.width - 180
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func restoreImageView() {
        leadingAnchorImageViewConstraint.constant = 20
        trailingAnchorImageViewConstraint.constant = -20
        heightAnchorImageViewConstraint.constant = view.frame.width - 40
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("image tapped")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func createPost() {
        showRefreshInsteadOfButton()
        
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "images").child("\(imageName).jpg")
        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.25) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                ref.downloadURL(completion: { url, error in
                    if let downloadUrl = url {
                        self.addPostFirebase(imageUrl: downloadUrl.absoluteString, description: self.descriptionTextView.text, rating: 0, timestamp: Date().timeIntervalSince1970, latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    func addPostFirebase(imageUrl: String, description: String, rating: Double, timestamp: Double, latitude: Double, longitude: Double) {
        var post = Post(userId: "1", imageUrl: imageUrl, description: description, rating: rating, timestamp: timestamp, latitude: latitude, longitude: longitude)
        let newPostReference = Database.database().reference(withPath: "posts").childByAutoId()
        let newPostId = newPostReference.key
        post.id = newPostId!
        let data = try! FirebaseEncoder().encode(post)
        newPostReference.setValue(data)
        print("New child was added successfully")
    }
    
    func showRefreshInsteadOfButton() {
        postButton.removeFromSuperview()
        let loading = UIActivityIndicatorView()
        view.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        loading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loading.startAnimating()
    }
    
}

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did begin editing")
        if textView.text == "Your description" {
            self.descriptionTextView.text = ""
            self.descriptionTextView.textColor = .black
            self.descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        }
        shrinkImageView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end editing")
        if textView.text == "" {
            self.descriptionTextView.text = "Your description"
            self.descriptionTextView.textColor = .gray
            self.descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        }
        restoreImageView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension NewPostViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
