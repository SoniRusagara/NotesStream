//
//  LoginScreenView.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit

class LoginScreenView: UIView {

    /*
    TD: Add in the following
     1. Fields: Email, Password
     2. Buttons: Login, Go to Register
    */
    
    // UI components for the "Login" screen
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           // Set the background color
           self.backgroundColor = .white
           
           // Initialize and set up UI components
           setupTextFieldEmail()
           setupLabelEmail()
           setupTextFieldPassword()
           setupLabelPassword()
           setupButtonLogin()
           setupButtonRegister()
           
           // Setup constraints
           initConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
        func setupButtonLogin(){
            loginButton = UIButton(type: .system)
            loginButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
            loginButton.setTitle("Login", for: .normal)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(loginButton)
            //self.view.addSubview(deleteButton)
        }
    
        // MARK: Setup Edit Button
       func setupButtonRegister() {
           registerButton = UIButton(type: .system)
           registerButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
           registerButton.setTitle("Register", for: .normal)
           registerButton.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(registerButton)
       }

       // MARK: Setting up UI Elements
        func setupLabelEmail() {
            emailLabel = UILabel()
            emailLabel.font = UIFont.systemFont(ofSize: 18)
            emailLabel.textColor = .black
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(emailLabel)
        }

        func setupLabelPassword() {
            passwordLabel = UILabel()
            passwordLabel.font = UIFont.systemFont(ofSize: 18)
            passwordLabel.textColor = .black
            passwordLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(passwordLabel)
        }
    
        func setupTextFieldEmail() {
            emailTextField = UITextField()
            emailTextField.placeholder = "Enter Email"
            emailTextField.borderStyle = .roundedRect
            emailTextField.keyboardType = .emailAddress
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(emailTextField)
        }

        func setupTextFieldPassword() {
            passwordTextField = UITextField()
            passwordTextField.placeholder = "Enter Password"
            passwordTextField.borderStyle = .roundedRect
            passwordTextField.keyboardType = .numberPad
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(passwordTextField)
        }

        
        // MARK: Function to update UI with contact details
//        func updateUI(with contact: Contact) {
//            labelName.text = "Name: \( contact.name)"
//            labelEmail.text = "Email: \(contact.email)"
//            labelPhone.text = "Phone: \(contact.phone)"
//        
//        }

    
    // MARK: - Constraints Setup
        func initConstraints() {
            NSLayoutConstraint.activate([
                // Email Label constraints
                emailLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80),
                emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

                // Email TextField constraints
                emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
                emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                emailTextField.heightAnchor.constraint(equalToConstant: 40),

                // Password Label constraints
                passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                passwordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                passwordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

                // Password TextField constraints
                passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
                passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                passwordTextField.heightAnchor.constraint(equalToConstant: 40),

                // Login Button constraints
                loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
                loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                loginButton.heightAnchor.constraint(equalToConstant: 50),

                // Register Button constraints
                registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
                registerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                registerButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

}
