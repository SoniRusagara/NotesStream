//
//  ViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import Alamofire

/// Main view controller for displaying the list of notes
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    /// The custom view containing the UI components
    let mainScreenView = MainScreenView()
    
    /// The data source for notes
    var notes: [Note] = []
    
    /// Load the custom view instead of storyboard/default view
    override func loadView() {
        view = mainScreenView
    }
    
    // todo: centralize to API client
    let headers: HTTPHeaders = [
        "x-access-token": "dev-user-1",     // matches your Lambda temp auth
        "Content-Type": "application/json"  // safe default
    ]

    /// Setup view after it’s loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // App title
        self.title = "My Notes 📝"
        
        /// Assign data source & delegate to the notes table view
        mainScreenView.tableViewNotes.dataSource = self
        mainScreenView.tableViewNotes.delegate = self
        /// Register the custom cell class so the table view can create/reuse cells with the "noteCell" identifier
        mainScreenView.tableViewNotes.register(NoteTableViewCell.self, forCellReuseIdentifier: "noteCell")

        
        /// Add action to the "Add Note" button to trigger navigation
        mainScreenView.addNoteButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        
        // fetch all notes when the main screen loads
        fetchAllNotes()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(onNoteDeleted(_:)),
            name: .noteDeleted,
            object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(onNoteCreated(_:)), name: .noteCreated, object: nil)
        
    }
    
    /// Handles tap on the "+" button and navigates to the Add Note screen
    @objc func addNoteButtonTapped() {
        let addNoteVC = AddNoteViewController()
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    

        
    //MARK: get all Notes...
    func fetchAllNotes() {
        // build the URL with the baseURL and the getall endpoint using URL() initializer
        guard let url = URL(string: APIConfigs.getAllNotes) else {
            print("❌ Invalid URL:", APIConfigs.getAllNotes)
            return
        }
        
        print("🌐 GET \(url.absoluteString)")

        // use url to make a request with Alamofire & call responseData() method for JSON parsing
        AF.request(url, method: .get, headers: headers).responseData { response in
            //MARK: retrieving the status code, since it is an optional value we need to unwrap it when we use it
            let status = response.response?.statusCode
            print("🔎 HTTP status:", status.map(String.init) ?? "nil")
            
            switch response.result {
            //MARK: there was no network error...
            case .success(let data):
                guard let uwStatusCode = status else {
                    print("❔ No HTTP status from server")
                    return
                }
                
                switch uwStatusCode {
                //MARK: the request was valid 200-level...
                case 200...299:
                    do {
                        // Parse JSON data into Note array
                        let fetchedNotes = try JSONDecoder().decode([Note].self, from: data)
                        
                        // Debug: counts + each note
                        print("🧮 decoded notes:", fetchedNotes.count)
                        
                        // Update notes array and reload table view on main thread
                        DispatchQueue.main.async {
                            self.notes = fetchedNotes
                            self.mainScreenView.tableViewNotes.reloadData()
                            print("✅ table reloaded, rows:", self.notes.count)
                        }
                        
                        print("Successfully fetched \(fetchedNotes.count) notes")
                        
                    } catch {
                        print("❌ JSON decode error:", error)
                        DispatchQueue.main.async {
                            self.showErrorAlert(message: "Failed to load notes. Please try again.")
                        }
                    }
                    
                //MARK: the request was not valid 400-level...
                case 400...499:
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("Client error: \(errorString)")
                    }
                    
                //MARK: probably a 500-level error...
                default:
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("Server error: \(errorString)")
                    }
                }
                
            //MARK: there was a network error...
            case .failure(let error):
                print("🌐 Network error:", error.localizedDescription)

                if let af = error.asAFError {
                    switch af {
                    case .sessionTaskFailed(let underlying):
                        if let urlErr = underlying as? URLError {
                            print("🔧 URLError.code:", urlErr.code.rawValue, "(\(urlErr.code))")
                        } else {
                            print("🔧 Underlying error:", underlying)
                        }
                    default:
                        print("🔧 AFError:", af)
                    }
                }

                // Helpful to see *everything* Alamofire captured
                debugPrint("🧾 Response dump:", response)

                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Server is experiencing issues. Please try again later.")
                }

            }
        }
    }


    
    // MARK: - Helper method to show user-friendly error messages
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Make sure we're on the main thread when presenting
        if Thread.isMainThread {
            present(alert, animated: true)
        } else {
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        let noteVC = AddNoteViewController()
        noteVC.loadNote(note: selectedNote) 
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    @objc private func onNoteCreated(_ n: Notification) {
        guard let created = n.object as? Note else { return }

        // Optimistic insert for instant UI
        notes.insert(created, at: 0)
        mainScreenView.tableViewNotes.reloadData()

        // Background reconcile with server truth
        fetchAllNotes()
    }
    
    @objc private func onNoteDeleted(_ n: Notification) {
        guard let id = n.object as? String else { return }

        if let row = notes.firstIndex(where: { $0.id == id }) {
            notes.remove(at: row)
            mainScreenView.tableViewNotes.performBatchUpdates({
                mainScreenView.tableViewNotes.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }, completion: nil)
        } else {
            // If we didn’t have it locally (or indices shifted), reconcile from server
            fetchAllNotes()
        }
    }


}


