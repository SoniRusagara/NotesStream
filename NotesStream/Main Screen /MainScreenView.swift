//
//  MainScreenView.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit

class MainScreenView: UIView {

    /*
    TD: Add the following
     Sections: List of notes, Profile button, Add Note button, Logout button
    */
    var tableViewNotes: UITableView!
    var addNoteButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewNotes()
        setupAddNoteButton()
        initConstraints()
    }
    
    
    /// Initialize and style the notes view
    func setupTableViewNotes() {
        tableViewNotes = UITableView()
        tableViewNotes.register(NoteTableViewCell.self, forCellReuseIdentifier: "noteCell")
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotes)
    }
    
    /// Initialize the AddNote Button
    func setupAddNoteButton() {
        addNoteButton = UIButton(type: .system)
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.layer.cornerRadius = 30
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addNoteButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // TableView fills most of the screen
            tableViewNotes.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableViewNotes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewNotes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableViewNotes.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // Floating Add button
            addNoteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                  addNoteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                  addNoteButton.widthAnchor.constraint(equalToConstant: 60),
                  addNoteButton.heightAnchor.constraint(equalToConstant: 60)
              ])
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    

}
