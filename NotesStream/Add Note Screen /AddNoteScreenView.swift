//
//  AddNoteScreenView.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit

class AddNoteScreenView: UIView {
    // variable to edit the note title
    var noteTitle: UITextField!
    
    // variable to hold the text of the note
    var noteBody: UITextView!
    
    // button to save current note
    var saveButton: UIButton!
    
    // button to share current note
    var shareButton: UIButton!
    
    // button to attach items such as images, files, audio
    var attachButton: UIButton!
    
    // variable to hold images within the note 
    var imagesCollectionView: UICollectionView!
    
    // array to store multiple images per note 
    var attachedImages: [UIImage] = []
    
    var filesTableView: UITableView!

    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           // Set the background color
           self.backgroundColor = .white
           
           // Initialize and set up UI components
           setupNoteTitle()
           setupNoteBody()
           setupAttachedImages()
           setupSaveButton()
           setupShareButton()
           setupAttachButton()
           setupFilesTableView()

           
           // Setup constraints
           initConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    // MARK: Setup Share Button
   func setupShareButton() {
       shareButton = UIButton(type: .system)
       // Use SF Symbol as button icon
       let image = UIImage(systemName: "square.and.arrow.up")
       shareButton.setImage(image, for: .normal)
     
       shareButton.tintColor = .systemPink
       //shareButton.setTitleColor(.systemPink, for: .normal)
       shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
       shareButton.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(shareButton)
   }
    
    // MARK: Setup Save Button
   func setupSaveButton() {
       saveButton = UIButton(type: .system)
       // Use SF Symbol as button icon
       let image = UIImage(systemName: "tray.and.arrow.down")
       saveButton.setImage(image, for: .normal)
  
       saveButton.tintColor = .systemPink
       //shareButton.setTitleColor(.systemPink, for: .normal)
       saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)

       saveButton.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(saveButton)
   }
    
    // MARK: Setup Attach Button
   func setupAttachButton() {
       attachButton = UIButton(type: .system)
       
       // Use SF Symbol as button icon
       let image = UIImage(systemName: "paperclip")
       attachButton.setImage(image, for: .normal)
      
       attachButton.tintColor = .systemPink
       //shareButton.setTitleColor(.systemPink, for: .normal)
       attachButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
       
       // Styling the attach button as a floating circular button 
       attachButton.layer.cornerRadius = 25
       attachButton.backgroundColor = .systemPink.withAlphaComponent(0.1)


       attachButton.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(attachButton)
   }
    
    // MARK: Add Image
    func addImage(_ image: UIImage) {
        attachedImages.append(image)
        imagesCollectionView.reloadData()
   }
    
    /// Sets up the note title input field with placeholder, bold font, and styling.
    /// This field allows the user to enter the title of the note.
   func setupNoteTitle() {
       noteTitle = UITextField()
       noteTitle.placeholder = "Enter note title..."
       noteTitle.font = UIFont.boldSystemFont(ofSize: 22)
       noteTitle.textColor = .black
       noteTitle.borderStyle = .none
       noteTitle.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(noteTitle)
    }
    
    /// Sets up the main note body input area where users can type multi-line note content.
    /// Uses a UITextView for flexible, scrollable input.
   func setupNoteBody() {
       noteBody = UITextView()
       noteBody.font = UIFont.systemFont(ofSize: 18)
       noteBody.textColor = .black
       noteBody.borderStyle = .none
       // Adds internal padding to the note body text view for better readability
       noteBody.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
       noteBody.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(noteBody)
     }
    
   func setupAttachedImages() {
       // Define a layout for the collection view
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
       layout.minimumLineSpacing = 10
       layout.minimumInteritemSpacing = 10
       layout.itemSize = CGSize(width: 100, height: 100) // thumbnail size
       
       
       // initialize the collection view with the layout
       imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       imagesCollectionView.backgroundColor = .clear
       imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
       
       // register a basic cell
       imagesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
       
       // add the collection view to the screen
       self.addSubview(imagesCollectionView)
          
      }
 
    /// Sets up the table view that displays attached files in a list
    func setupFilesTableView() {
        filesTableView = UITableView()
        // Register a custom cell for showing file name + icon
        filesTableView.register(FileTableViewCell.self, forCellReuseIdentifier: "fileCell")
        // Auto layout setup
        filesTableView.translatesAutoresizingMaskIntoConstraints = false
        filesTableView.isScrollEnabled = false // makes it grow with content
        self.addSubview(filesTableView) // Add to view hierarchy
    }


    
    
    
    
    
    // MARK: Setting up Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Title text field at the top
            noteTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            noteTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            noteTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Save button aligned to top-right
            saveButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Share button to the left of Save
            shareButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -16),

            // Body text view below the note title
            noteBody.topAnchor.constraint(equalTo: noteTitle.bottomAnchor, constant: 12),
            noteBody.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            noteBody.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            noteBody.heightAnchor.constraint(equalToConstant: 200),

            // Image collection view below the note body
            imagesCollectionView.topAnchor.constraint(equalTo: noteBody.bottomAnchor, constant: 12),
            imagesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imagesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 120),

            // 📄 File list table view below the image collection
            filesTableView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 12),
            filesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            filesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            filesTableView.heightAnchor.constraint(equalToConstant: 150), // you can adjust this later

            // 📎 Attach button at bottom-right, floating
            attachButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            attachButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            attachButton.widthAnchor.constraint(equalToConstant: 50),
            attachButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }


    
    

}
