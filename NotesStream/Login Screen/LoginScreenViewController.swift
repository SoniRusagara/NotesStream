//
//  LoginScreenViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 11/7/24.
//

import UIKit
import Alamofire

class LoginScreenViewController: UIViewController {
    
    // Initialize loginScreenView object
    var loginScreenView = LoginScreenView()
    
    
    override func loadView() {
        view = loginScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login Screen"
        
        // Set the background color
        view.backgroundColor = .white
        

        // Do any additional setup after loading the view.
        // Add button actions
       loginScreenView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
       loginScreenView.registerButton.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
    }
    
    @objc func handleGoToRegister() {
        // Navigate to Register screen
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func handleLogin() {
        // Make call to API to login user 
    }
    
    func navigateToMainScreen() {
        let mainScreenVC = ViewController()
        navigationController?.setViewControllers([mainScreenVC], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
