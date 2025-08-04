//
//  RegisterViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    // Initialize registerScreenView object
    var registerScreenView = RegisterScreenView()
    
    override func loadView() {
        view = registerScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add button actions for the register button
        registerScreenView.registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
    }
    

    // Simplified version of registerUser method
    @objc func registerUser() {
        guard let name = registerScreenView.nameTextField.text, !name.isEmpty,
              let email = registerScreenView.emailTextField.text, isValidEmail(email),
              let password = registerScreenView.passwordTextField.text, !password.isEmpty else {
            showAlert("Invalid Input", "Please enter a valid name, email, and password.")
            return
        }
        
        // Call the register API
        let registerUrl = "http://apis.sakibnm.work:3000/api/auth/register"
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        AF.request(registerUrl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], let token = json["token"] as? String {
                    // Registration successful, save the token
                    UserDefaults.standard.set(token, forKey: "authToken")
                    self.navigateToMainScreen()
                } else {
                    self.showAlert("Registration Failed", "Unable to register. Please try again.")
                }
            case .failure(let error):
                print("Register error: \(error)")
                self.showAlert("Network Error", "Failed to connect to server. Please try again.")
            }
        }
    }
    
    // Navigate to the main screen after successful registration
       func navigateToMainScreen() {
           let mainScreenVC = ViewController()
           navigationController?.setViewControllers([mainScreenVC], animated: true)
       }
       
       // Helper method to show an alert
       func showAlert(_ title: String, _ message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
       
       // Helper method to validate email format
       func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: email)
       }


}
