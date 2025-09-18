//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import UniformTypeIdentifiers
import AVFoundation
import Alamofire


class AddNoteViewController: UIViewController, AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /// Casts the main view to `AddNoteScreenView` for easy access to its subviews
    var addNoteScreenView: AddNoteScreenView {
        return self.view as! AddNoteScreenView
    }

    /// Store attached file URLs
    var attachedFiles: [URL] = []
    
    let headers: HTTPHeaders = [
        "x-access-token": "dev-user-1",     // temp auth → maps to userId
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    
    /// Responsible for handling the actual recording process (start, stop, save).
    var audioRecorder: AVAudioRecorder?

    /// Manages the audio behavior of the app (e.g., mic access, playback mode).
    var recordingSession: AVAudioSession!

    /// Variable to store created notes
    var createdNote: Note?

    override func loadView() {
        view = AddNoteScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attach action methods to buttons
        addNoteScreenView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        addNoteScreenView.moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        addNoteScreenView.attachButton.addTarget(self, action: #selector(attachTapped), for: .touchUpInside)
        addNoteScreenView.filesTableView.dataSource = self
        setupAudioSession()
        
        if let note = createdNote {
            addNoteScreenView.noteTitle.text = note.title
            addNoteScreenView.noteBody.text = note.content
        }

    }
    
    // Function that loads a created note
    func loadNote(note: Note){
        self.createdNote = note
    }

    // MARK: - Share Note
    @objc func shareTapped() {
        let titleText = addNoteScreenView.noteTitle.text ?? ""
        let bodyText = addNoteScreenView.noteBody.text ?? ""
        let noteToShare = "\(titleText)\n\n\(bodyText)"
        let activityVC = UIActivityViewController(activityItems: [noteToShare], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    
    // MARK: - Show Attachment Options
    @objc func attachTapped() {
        // Prevent multiple alerts being shown at the same time
        if presentedViewController != nil { return }
        
        let picker = UIAlertController(title: "Add Attachment", message: nil, preferredStyle: .actionSheet)

        // Attach Photo
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            //print("Attach photo tapped")
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)

        }
        photo.setValue(UIImage(systemName: "photo"), forKey: "image")
        picker.addAction(photo)

        // Attach File
        let file = UIAlertAction(title: "File", style: .default) { _ in
            self.presentFilePicker()
            /// Note: No files attached yet but functionality works TODO~test out adding in attachments
        }
        file.setValue(UIImage(systemName: "doc"), forKey: "image")
        picker.addAction(file)

        // Attach Audio
        let audio = UIAlertAction(title: "Audio", style: .default) { _ in
            print("Attach audio tapped")
            self.recordAudio()
        }
        audio.setValue(UIImage(systemName: "waveform"), forKey: "image")
        picker.addAction(audio)

        // Optional: Scan Document
        let scan = UIAlertAction(title: "Scan Document", style: .default) { _ in
            print("Scan document tapped")
            // TODO: Use VisionKit scanner
        }
        scan.setValue(UIImage(systemName: "doc.viewfinder"), forKey: "image")
        picker.addAction(scan)

        // Cancel
        picker.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(picker, animated: true)
    }
    
    // MARK: - More (3-dots) Menu
    @objc func moreTapped() {
        // Prevents stacking multiple sheets
        if presentedViewController != nil { return }

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Share option → reusing my existing shareTapped()
        sheet.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.shareTapped()
        })

        // Delete option → goes to a confirm step (next section)
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.confirmDelete()
        })

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad safety to avoid a crash
        if let pop = sheet.popoverPresentationController {
            pop.sourceView = addNoteScreenView.moreButton
            pop.sourceRect = addNoteScreenView.moreButton.bounds
        }

        present(sheet, animated: true)
    }
    
    

    
    // MARK: - Save Note Button
    @objc func saveTapped() {
        let title = addNoteScreenView.noteTitle.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let body  = addNoteScreenView.noteBody.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !title.isEmpty || !body.isEmpty else {
            showAlert("Please enter a title or body")
            return
        }

        setSaving(true)

        addNoteToAPI(title: title, content: body) { result in
            DispatchQueue.main.async {
                self.setSaving(false)
                switch result {
                case .success(let createdNote):
                    // 1) Let the list know a note was created (optimistic refresh there)
                    NotificationCenter.default.post(name: .noteCreated, object: createdNote)

                    // 2) Keep this screen open; store the created note
                    self.createdNote = createdNote

                    // 3) Let the user choose what to do next
                    let alert = UIAlertController(
                        title: "Saved ✅",
                        message: "Your note was saved. Keep editing or view the list?",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Keep Editing", style: .default))
                    alert.addAction(UIAlertAction(title: "Go to List", style: .default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)

                case .failure(let err):
                    print("❌ Add note failed:", err)
                    self.showAlert("Failed to save. Please try again.")
                }
            }
        }
    }
    
    

    
    
    // MARK: add a new Note via POST /api/note/post
    func addNoteToAPI(title: String, content: String,
                      completion: @escaping (Result<Note, Error>) -> Void) {
        guard let url = URL(string: APIConfigs.addNote) else {
            print("❌ Invalid URL:", APIConfigs.addNote)
            completion(.failure(NSError(domain: "BadURL", code: -1)))
            return
        }

        print("🌐 POST \(url.absoluteString)")

        let payload: [String: String] = [
            "title": title,
            "content": content
        ]

        AF.request(url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
          .responseData { response in
            let status = response.response?.statusCode
            print("🔎 HTTP status:", status.map(String.init) ?? "nil")

            switch response.result {
            case .success(let data):
                guard let code = status else {
                    completion(.failure(NSError(domain: "NoStatus", code: -1)))
                    return
                }
                switch code {
                case 200...299:
                    do {
                        let created = try JSONDecoder().decode(Note.self, from: data)
                        print("✅ Created note:", created)
                        completion(.success(created))
                    } catch {
                        print("❌ JSON decode error:", error)
                        if let raw = String(data: data, encoding: .utf8) { print("🧾 Raw body:", raw) }
                        completion(.failure(error))
                    }

                case 400...499:
                    let body = String(data: data, encoding: .utf8) ?? ""
                    print("🙅‍♀️ Client error:", body)
                    completion(.failure(NSError(domain: "ClientError", code: code, userInfo: ["body": body])))

                default:
                    let body = String(data: data, encoding: .utf8) ?? ""
                    print("💥 Server error:", body)
                    completion(.failure(NSError(domain: "ServerError", code: code, userInfo: ["body": body])))
                }

            case .failure(let error):
                print("🌐 Network error:", error.localizedDescription)
                completion(.failure(error))
            }
          }
    }
    
    // MARK: - Confirm, then delete
    func confirmDelete() {
        // Need an id for deletion
        guard let id = createdNote?.id, !id.isEmpty else {
            showAlert("Save the note first before deleting.")
            return
        }

        let alert = UIAlertController(
            title: "Delete Note?",
            message: "This cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteCurrentNote(id: id)
        })
        present(alert, animated: true)
    }
    
    @objc func deleteCurrentNote(id: String) {
        setSaving(true)

        deleteNoteFromAPI(id: id) { result in
            DispatchQueue.main.async {
                self.setSaving(false)
                switch result {
                case .success:
                    // Tell the list screen to remove this note
                    NotificationCenter.default.post(name: .noteDeleted, object: id)

                    // Show confirmation, then pop back to the list
                    let a = UIAlertController(title: "Deleted", message: "Your note was deleted.", preferredStyle: .alert)
                    a.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(a, animated: true)

                case .failure(let err):
                    print("❌ Delete failed:", err)
                    self.showAlert("Failed to delete. Please try again.")
                }
            }
        }
    }
    
    
    // MARK: delete a Note via POST /api/note/delete
    func deleteNoteFromAPI(id: String,
                           completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: APIConfigs.deleteNote) else {
            print("❌ Invalid URL")
            completion(.failure(NSError(domain: "BadURL", code: -1)))
            return
        }

        print("🌐 POST \(url.absoluteString)")

        let payload = ["id": id]
//        let headers: HTTPHeaders = [
//            "x-access-token": "dev-user-1",
//            "Content-Type": "application/json"
//        ]

        AF.request(url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
          .responseData { response in
            let status = response.response?.statusCode
            print("🔎 HTTP status:", status.map(String.init) ?? "nil")

            switch response.result {
            case .success(let data):
                guard let code = status else {
                    completion(.failure(NSError(domain: "NoStatus", code: -1)))
                    return
                }
                switch code {
                case 200...299:
                    // verify {"ok":true}
                    if let ok = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                       (ok["ok"] as? Bool) == true {
                        print("✅ Deleted note:", id)
                        completion(.success(()))
                    } else {
                        // Treat any 2xx as success if backend sometimes returns 204
                        completion(.success(()))
                    }
                default:
                    let body = String(data: data, encoding: .utf8) ?? ""
                    print("💥 Error \(code):", body)
                    completion(.failure(NSError(domain: "HTTP", code: code, userInfo: ["body": body])))
                }

            case .failure(let error):
                print("🌐 Network error:", error.localizedDescription)
                completion(.failure(error))
            }
          }
    }
    
    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            addNoteScreenView.addImage(image)
        }
    }


    // MARK: - Show File Picker
    func presentFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    private func setSaving(_ saving: Bool) {
        addNoteScreenView.saveButton.isEnabled = !saving
        addNoteScreenView.saveButton.alpha = saving ? 0.5 : 1.0
    }

    private func showAlert(_ msg: String) {
        let a = UIAlertController(title: "Oops", message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}


// MARK: - UIDocumentPickerDelegate
extension AddNoteViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(selectedFileURL.lastPathComponent)

        do {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.copyItem(at: selectedFileURL, to: destinationURL)
            }
            print("✅ File saved to: \(destinationURL.lastPathComponent)")
            addFileAttachment(from: destinationURL)
        } catch {
            print("❌ Failed to save file: \(error)")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker cancelled")
    }

    func addFileAttachment(from url: URL) {
        attachedFiles.append(url)
        print("📎 Attached file: \(url.lastPathComponent)")
        // TODO: Update your UI to show file visually
        addNoteScreenView.filesTableView.reloadData()

    }
    
    /// Starts audio recording, saves the file locally, and adds it as an attachment
    func recordAudio() {
        // Generate a unique filename with .m4a extension
        let filename = UUID().uuidString + ".m4a"
        
        // Get the app's documents directory path
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Create the full file URL where the audio will be saved
        let audioURL = documentsPath.appendingPathComponent(filename)

        // Define the recording settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),       // Use AAC format
            AVSampleRateKey: 12000,                         // 12 kHz sample rate
            AVNumberOfChannelsKey: 1,                       // Mono channel
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // High-quality recording
        ]

        do {
            // Initialize the recorder with the file URL and settings
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.delegate = self
            
            // Start recording
            audioRecorder?.record()
            print("🎙️ Recording started...")

            // Automatically stop recording after 5 seconds 
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.audioRecorder?.stop()
                print("🛑 Recording stopped")
                
                // Attach the recorded audio file to the note
                self.addFileAttachment(from: audioURL)
            }

        } catch {
            // If recording fails, log the error
            print("❌ Failed to start recording: \(error)")
        }
    }

    
    /// Configures the app's audio session to allow recording and requests mic permission
    func setupAudioSession() {
        // Get the shared audio session instance
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            // Set the audio category to allow recording and playback
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true) // Activate the session
            // Request permission to use the microphone
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        print("🎙️ Microphone permission denied.")
                    }
                }
            }
        } catch {
            // Catch and report any errors in setting up the session
            print("❌ Failed to setup audio session: \(error)")
        }
    }

}

// MARK: - TableView DataSource
extension AddNoteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachedFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
        let fileURL = attachedFiles[indexPath.row]
        cell.titleLabel.text = fileURL.lastPathComponent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileURL = attachedFiles[indexPath.row]
        
        let docController = UIDocumentInteractionController(url: fileURL)
        docController.delegate = self
        docController.presentPreview(animated: true)
    }
    
    // Allow swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove file from the array
            attachedFiles.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
}

extension AddNoteViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension AddNoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addNoteScreenView.attachedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let image = addNoteScreenView.attachedImages[indexPath.row]

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = cell.contentView.bounds

        // Remove old views
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)

        return cell
    }
}



