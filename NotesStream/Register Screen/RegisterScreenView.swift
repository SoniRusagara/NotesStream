//
//  RegisterScreenView.swift
//  NotesApp
//
//  Created by Soni Rusagara on 11/7/24.
//

import UIKit

class RegisterScreenView: UIView {
    
    // UI components for the "Register" screen
    var nameLabel: UILabel!
    var nameTextField: UITextField!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           // Set the background color
           self.backgroundColor = .white
           
           // Initialize and set up UI components
           setupTextFieldEmail()
           setupLabelEmail()
           setupLabelName()
           setupTextFieldName()
           setupTextFieldPassword()
           setupLabelPassword()
           setupButtonRegister()
           
           // Setup constraints
           initConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
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
    func setupLabelName() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }
    
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
    
    func setupTextFieldName() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.keyboardType = .emailAddress
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTextField)
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
                // Name Label constraints
                nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80),
                nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                
                // Name TextField constraints
                nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                nameTextField.heightAnchor.constraint(equalToConstant: 40),
                
                // Email Label constraints
                emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
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
                
                // Register Button constraints
                registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
                registerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                registerButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
