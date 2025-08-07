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

        // Do any additional setup after loading the view.
    }
    
    @objc func attachImageTapped() {
        // Show image picker here
    }


}
