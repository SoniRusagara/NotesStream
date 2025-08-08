//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Soni Rusagara on 8/4/25.
//

import UIKit
import UniformTypeIdentifiers

class AddNoteViewController: UIViewController{
    
    /// Casts the main view to `AddNoteScreenView` for easy access to its subviews
    var addNoteScreenView: AddNoteScreenView {
        return self.view as! AddNoteScreenView
    }

    /// Store attached file URLs
    var attachedFiles: [URL] = []

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
            // TODO: Audio picker or recorder
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


