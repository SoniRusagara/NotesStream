//
//  ProfileScreenViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 11/7/24.
//

import UIKit

class ProfileScreenViewController: UIViewController {
    
    // Initialize displayScreenView object
    var profileScreenView = ProfileScreenView()
    
    
    override func loadView() {
        view = profileScreenView
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile Details"
        
        // Set the background color
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        // td: this is from prev hw look to see if it can fit or how to update 
        // Update the view with contact details
        //profileScreenView.updateUI(with: contact)
        
        // Add target for Edit button tap
        //profileScreenView.editButton.addTarget(self, action: #selector(onEditButtonTapped), for: .touchUpInside)
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
