//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    /// Casts the main view to `AddNoteScreenView` for easy access to its subviews
    var addNotesScreenView: AddNoteScreenView {
        return self.view as! AddNoteScreenView
    }
    
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
        // Access title & body text
        let titleText = addNotesScreenView.noteTitle.text ?? ""
        let bodyText = addNotesScreenView.noteBody.text ?? ""
        
        // Combine them into a single string
        let noteToShare = "\(titleText)\n\n\(bodyText)"
        
        // Create activity view controller
        let activityViewController = UIActivityViewController(activityItems: [noteToShare], applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }


}
