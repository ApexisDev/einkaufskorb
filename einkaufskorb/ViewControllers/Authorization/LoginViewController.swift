//
//  loginViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 25.06.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            //emailTextField.underlined()
            emailTextField.placeholder = NSLocalizedString("email", comment: "")
        }
    }
    
    @IBOutlet weak var upperNavigationBar: UINavigationItem!
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            //passwordTextField.underlined()
            passwordTextField.isSecureTextEntry = true
        }
    }

    @IBOutlet weak var LoginButton: UIButton!{
        didSet{
            LoginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
            //LoginButton.filled(LoginButton)
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!{
        didSet{
            errorLabel.alpha = 0
        }
    }
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
           // signUpButton.hollow(signUpButton)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        
        //hardcoded auth to skip login screen during development
        Auth.auth().signIn(withEmail: "apexis.dev@gmail.com", password: "29Jw0102!", completion: nil)
        if Auth.auth().currentUser != nil {
            self.transitionToHomeScreen()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        let mail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: mail, password: password) { (result, error) in
        // Check for errors
        if error != nil {
            // Theres an error
            self.showError("Error logging in user")
            
        } else {
            self.transitionToHomeScreen()
            }
        }
    }
    /*
    @IBAction func onSignUpButtonTapped(_ sender: Any) {
        self.transitionToSignUpScreen()
    }
    */
    
    // Style the elements in this Activity
    func styleElements() {
        emailTextField.underlined()
        passwordTextField.underlined()
        LoginButton.filled(LoginButton)
        signUpButton.hollow(signUpButton)
    }
    
    // Show home screen
    
    func transitionToHomeScreen() {
        
        guard let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController else { return }
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
        
    }

}

