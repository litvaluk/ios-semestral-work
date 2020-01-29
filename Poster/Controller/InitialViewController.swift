//
//  InitialViewController.swift
//  Poster
//
//  Created by Lukáš Litvan on 27/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    let logoImageView = UIImageView()
    let loginButton = UIButton()
    let signupButton = UIButton()
    
    override func loadView() {
        super.loadView()
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        configureLogoImageView()
        configureLoginButton()
        configureSignupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureLogoImageView() {
        logoImageView.image = UIImage(named: "PosterHomeScreenLogo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    func configureLoginButton() {
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = Colors.black.cgColor
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = Colors.white
        loginButton.setTitleColor(Colors.black, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -20).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
    }
    
    func configureSignupButton() {
        signupButton.layer.cornerRadius = 20
        signupButton.clipsToBounds = true
        signupButton.backgroundColor = Colors.black
        signupButton.setTitleColor(Colors.white, for: .normal)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.addTarget(self, action: #selector(showSignupScreen), for: .touchUpInside)
    }
    
    @objc func showLoginScreen() {
        let loginViewController = LoginViewController()
        loginViewController.navigationItem.title = "Login"
        loginViewController.view.backgroundColor = Colors.white
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc func showSignupScreen() {
        let signupViewController = SignupViewController()
        signupViewController.navigationItem.title = "Sign Up"
        signupViewController.view.backgroundColor = Colors.white
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }

}
