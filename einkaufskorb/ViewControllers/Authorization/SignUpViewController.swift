//
//  signUpViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 25.06.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.placeholder = "First name"
        }
    }
    
    @IBOutlet weak var lastNameTextField: UITextField!{
        didSet {
            lastNameTextField.placeholder = "Last name"
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!{
        didSet{
            repeatPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var upperNavigationBar: UINavigationItem!{
        didSet{
            upperNavigationBar.title = "Register"
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet{
            signUpButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!{
        didSet{
            errorLabel.alpha = 0
        }
    }
    @IBOutlet weak var transitionToLoginViewButton: UIButton!{
        didSet{
           // transitionToLoginViewButton.setTitle(NSLocalizedString("transitionToLoginViewButton", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!{
        didSet{
            navigationBar.title = ""
        }
    }
    // "KEY" = "VALUE"
    // NSLocalizedString("KEY", comment: "VALUE")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Show navigationbar
        //navigationController?.setNavigationBarHidden(false, animated: true)
        styleElements()
        // Do any additional setup after loading the view.
    }
    
    // Style Elements
    func styleElements() {
        
        firstNameTextField.underlined()
        lastNameTextField.underlined()
        emailTextField.underlined()
        passwordTextField.underlined()
        repeatPasswordTextField.underlined()
        signUpButton.filled(signUpButton)
//        transitionToLoginViewButton.hollow(transitionToLoginViewButton)
        
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are all correct
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isnt secure enough
            return "Please enter a passwort that contains at least 8 characters, a special character an a number"
        }
        //Check if passwords match
        let repeatedPassword = repeatPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedPassword != repeatedPassword {
            return "Passwords do not match each other"
        }
        
        return nil
    }
    
    @IBAction func transitionToLoginButtonTapped(_ sender: Any) {
        self.transitionToLoginScreen()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // Something is wrong with the fields, show error message
            showError(error!)
        } else {
            createUser()
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func createUser() {
        
        // Create clean version of data
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let data = ["firstname": firstName, "lastname": lastName, "email": mail]
        
        Auth.auth().createUser(withEmail: mail, password: password) { (result, error) in
            // Check for errors
            if error != nil {
                // Theres an error
                self.showError("Error creating user")
            } else {
                let db = Firestore.firestore()
                guard let userUID = result?.user.uid else { return }
                db.collection("users").document(userUID)
                    .setData(data) {(error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        } else {
                            print("Document successfully written")
                            print(userUID)
                        }
                }
            }
        }
        self.transitionToLoginScreen()
    }
    
    // Show Login Screen
    func transitionToLoginScreen() {
        
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
    
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    
    }
    
}
