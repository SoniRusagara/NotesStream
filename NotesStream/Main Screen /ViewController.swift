//
//  ViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import Alamofire

/// Main view controller for displaying the list of notes
class ViewController: UIViewController, UITableViewDataSource {
    
    /// The custom view containing the UI components
    let mainScreenView = MainScreenView()
    
    /// The data source for notes
    var notes: [Note] = []
    
    /// Load the custom view instead of storyboard/default view
    override func loadView() {
        view = mainScreenView
    }

    /// Setup view after it’s loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Assign data source to the notes table view
        mainScreenView.tableViewNotes.dataSource = self
        
        /// Add action to the "Add Note" button to trigger navigation
        mainScreenView.addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        
        /// Load mock notes using the mock service
        loadMockNotes()
        
    }
    
    /// Handles tap on the "+" button and navigates to the Add Note screen
    @objc func addNoteTapped() {
        let addNoteVC = AddNoteViewController()
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    /// Fetch notes from the mock service
    func loadMockNotes() {
        MockNotesService.shared.fetchNotes { notes in
            self.notes = notes
            self.mainScreenView.tableViewNotes.reloadData()
        }
    }
    
    // MARK: - TableView DataSource Methods
    
    /// Number of rows = number of notes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    /// Configure each table view cell with note data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.previewLabel.text = note.content
        cell.dateLabel.text = note.createdAt
        
        
        return cell
    }
}

