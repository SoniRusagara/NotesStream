//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import UniformTypeIdentifiers
import AVFoundation


class AddNoteViewController: UIViewController, AVAudioRecorderDelegate{
    
    /// Casts the main view to `AddNoteScreenView` for easy access to its subviews
    var addNoteScreenView: AddNoteScreenView {
        return self.view as! AddNoteScreenView
    }

    /// Store attached file URLs
    var attachedFiles: [URL] = []
    
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
        addNoteScreenView.shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
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

    // MARK: - Save Note (placeholder)
    @objc func saveTapped() {
        print("Save button tapped")
    }

    // MARK: - Show Attachment Options
    @objc func attachTapped() {
        // Prevent multiple alerts being shown at the same time
        if presentedViewController != nil { return }
        
        let picker = UIAlertController(title: "Add Attachment", message: nil, preferredStyle: .actionSheet)

        // Attach Photo
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            print("Attach photo tapped")
            // TODO: Show image picker
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

    // MARK: - Show File Picker
    func presentFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
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


