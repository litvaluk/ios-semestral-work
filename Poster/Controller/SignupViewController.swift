//
//  SignupViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 28/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class SignupViewController: UIViewController {

    let emailLabel = UILabel()
    let emailTextField = TextFieldWithPadding()
    let usernameLabel = UILabel()
    let usernameTextField = TextFieldWithPadding()
    let passwordLabel = UILabel()
    let passwordTextField = TextFieldWithPadding()
    let descriptionLabel = UILabel()
    let descriptionTextField = TextFieldWithPadding()
    let errorLabel = UILabel()
    let signupButton = UIButton()
    let loading = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        addElementsToView()
        configureElements()
    }
    
    func addElementsToView() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(errorLabel)
        view.addSubview(loading)
        view.addSubview(signupButton)
    }
    
    func configureElements() {
        configureEmailLabel()
        configureEmailTextField()
        configureUsernameLabel()
        configureUsernameTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureDescriptionLabel()
        configureDescriptionTextField()
        configureErrorLabel()
        configureLoading()
        configureSignupButton()
    }
    
    func configureEmailLabel() {
        emailLabel.text = "Email"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureEmailTextField() {
        emailTextField.backgroundColor = Colors.lightGray
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureUsernameLabel() {
        usernameLabel.text = "Username"
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureUsernameTextField() {
        usernameTextField.backgroundColor = Colors.lightGray
        usernameTextField.layer.cornerRadius = 20
        usernameTextField.clipsToBounds = true
        usernameTextField.returnKeyType = .done
        usernameTextField.delegate = self
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configurePasswordLabel() {
        passwordLabel.text = "Password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 5).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configurePasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = Colors.lightGray
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 3).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureDescriptionTextField() {
        descriptionTextField.backgroundColor = Colors.lightGray
        descriptionTextField.layer.cornerRadius = 20
        descriptionTextField.clipsToBounds = true
        descriptionTextField.returnKeyType = .done
        descriptionTextField.delegate = self
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureErrorLabel() {
        errorLabel.text = ""
        errorLabel.textColor = Colors.red
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 2
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureLoading() {
        loading.isHidden = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        loading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configureSignupButton() {
        signupButton.addTarget(self, action: #selector(signupAndLogin), for: .touchUpInside)
        signupButton.backgroundColor = Colors.black
        signupButton.layer.cornerRadius = 20
        signupButton.clipsToBounds = true
        signupButton.setTitleColor(Colors.white, for: .normal)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func signupAndLogin() {
        self.errorLabel.text = ""
        startRefreshing()
        
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (result, error) in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
                self.stopRefreshing()
                print(error)
                return
            }
            self.addUserFirebase(id: (result?.user.uid)!, name: self.usernameTextField.text ?? "", description: self.descriptionTextField.text ?? "")
            self.view.window?.rootViewController = TabBarController()
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func addUserFirebase(id: String, name: String, description: String) {
        let user = User(id: id, name: name, description: description)
        let newUserReference = Database.database().reference(withPath: "users").child(id)
        let data = try! FirebaseEncoder().encode(user)
        newUserReference.setValue(data)
    }
    
    func startRefreshing() {
        signupButton.isHidden = true
        loading.isHidden = false
        loading.startAnimating()
    }
    
    func stopRefreshing() {
        loading.stopAnimating()
        loading.isHidden = true
        signupButton.isHidden = false
    }
    
}

extension SignupViewController: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}
