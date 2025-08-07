//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    override func loadView() {
        view = AddNoteScreenView()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let screenView = view as? AddNoteScreenView else { return }
        
        // Attach action methods
        screenView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        screenView.shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        screenView.attachButton.addTarget(self, action: #selector(attachImageTapped), for: .touchUpInside)
    }
    
    @objc func attachImageTapped() {
        // Show image picker logic here
        print("Attach button tapped")
    }
    
    @objc func saveTapped() {
        print("Save button tapped")
    }
    
    @objc func shareTapped() {
        print("Share button tapped")
    }


}
