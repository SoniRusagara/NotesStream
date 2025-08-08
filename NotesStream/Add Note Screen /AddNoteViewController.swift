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
        screenView.attachButton.addTarget(self, action: #selector(attachTapped), for: .touchUpInside)
    }
    
    @objc func attachTapped() {
        let picker = UIAlertController(title: "Add Attachment", message: nil, preferredStyle: .actionSheet)

        // Photo
        let photoAction = UIAlertAction(title: "Photo", style: .default, handler: { _ in
            print("Attach photo tapped")
        })
        photoAction.setValue(UIImage(systemName: "photo"), forKey: "image")
        picker.addAction(photoAction)

        // File
        let fileAction = UIAlertAction(title: "File", style: .default, handler: { _ in
            print("Attach file tapped")
        })
        fileAction.setValue(UIImage(systemName: "doc"), forKey: "image")
        picker.addAction(fileAction)

        // Audio
        let audioAction = UIAlertAction(title: "Audio", style: .default, handler: { _ in
            print("Attach audio tapped")
        })
        audioAction.setValue(UIImage(systemName: "waveform"), forKey: "image")
        picker.addAction(audioAction)

        // Scan Document
        let scanAction = UIAlertAction(title: "Scan Document", style: .default, handler: { _ in
            print("Scan document tapped")
        })
        scanAction.setValue(UIImage(systemName: "doc.viewfinder"), forKey: "image")
        picker.addAction(scanAction)

        // Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        picker.addAction(cancel)

        present(picker, animated: true)
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
