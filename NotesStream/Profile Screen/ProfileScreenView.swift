//
//  ProfileScreenView.swift
//  NotesApp
//
//  Created by Soni Rusagara on 11/5/24.
//  Displays: User name and email

import UIKit

class ProfileScreenView: UIView {
    
    // UI components for the "Profile" screen
    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelPhone: UILabel!
    var editButton: UIButton!

    override init(frame: CGRect) {
           super.init(frame: frame)
           
           // Set the background color
           self.backgroundColor = .white
           
           // Initialize and set up UI components
           setupLabelName()
           setupLabelEmail()
           setupLabelPhone()
           setupButtonEdit()
           
           // Setup constraints
           initConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    

        // MARK: Setup Edit Button
       func setupButtonEdit() {
           editButton = UIButton(type: .system)
           editButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
           editButton.setTitle("Edit Contact", for: .normal)
           editButton.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(editButton)
       }

       // MARK: Setting up UI Elements
        func setupLabelName() {
            labelName = UILabel()
            labelName.font = UIFont.boldSystemFont(ofSize: 24)
            labelName.textColor = .black
            labelName.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(labelName)
        }

        func setupLabelEmail() {
            labelEmail = UILabel()
            labelEmail.font = UIFont.systemFont(ofSize: 18)
            labelEmail.textColor = .black
            labelEmail.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(labelEmail)
        }

        func setupLabelPhone() {
            labelPhone = UILabel()
            labelPhone.font = UIFont.systemFont(ofSize: 18)
            labelPhone.textColor = .black
            labelPhone.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(labelPhone)
        }

        // TD: fix w updated hw
        
        // MARK: Function to update UI with contact details
//        func updateUI(with contact: Contact) {
//            labelName.text = "Name: \( contact.name)"
//            labelEmail.text = "Email: \(contact.email)"
//            labelPhone.text = "Phone: \(contact.phone)"
        
        

    
        // MARK: Setting up Constraints
        func initConstraints() {
            NSLayoutConstraint.activate([
                        // Constraints for labelName (below the profile image)
                        labelName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
                        labelName.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centered horizontally
                        labelName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                        
                        // Constraints for labelEmail
                        labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 16),
                        labelEmail.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centered horizontally
                        labelEmail.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
                        
                        // Constraints for labelPhone
                        labelPhone.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 16),
                        labelPhone.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centered horizontally
                        labelPhone.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
                        
                        // Constraints for the Edit Button
                        editButton.topAnchor.constraint(equalTo: labelPhone.bottomAnchor, constant: 20),
                        editButton.centerXAnchor.constraint(equalTo: self.centerXAnchor), // Centered horizontally
                
            ])
        }

}
