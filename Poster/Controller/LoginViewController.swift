//
//  LoginViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 27/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    let emailLabel = UILabel()
    let emailTextField = TextFieldWithPadding()
    let passwordLabel = UILabel()
    let passwordTextField = TextFieldWithPadding()
    let errorLabel = UILabel()
    let loginButton = UIButton()
    let loading = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        addElementsToView()
        configureElements()
    }
    
    func addElementsToView() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loading)
        view.addSubview(errorLabel)
        view.addSubview(loginButton)
    }
    
    func configureElements() {
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureErrorLabel()
        configureLoading()
        configureLoginButton()
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
    
    func configurePasswordLabel() {
        passwordLabel.text = "Password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
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
    
    func configureErrorLabel() {
        errorLabel.text = ""
        errorLabel.textColor = Colors.red
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 2
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
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
    
    func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.backgroundColor = Colors.black
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.setTitleColor(Colors.white, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func login() {
        self.errorLabel.text = ""
        startRefreshing()
        
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (result, error) in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
                self.stopRefreshing()
                print(error)
                return
            }
            self.view.window?.rootViewController = TabBarController()
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func startRefreshing() {
        loginButton.isHidden = true
        loading.isHidden = false
        loading.startAnimating()
    }
    
    func stopRefreshing() {
        loading.stopAnimating()
        loading.isHidden = true
        loginButton.isHidden = false
    }

}

extension LoginViewController: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}
