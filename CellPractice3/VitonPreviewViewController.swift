//
//  VitonPreviewViewController.swift
//  CellPractice3
//
//  Created by admin29 on 05/11/24.
//
//


import UIKit

class VitonPreviewViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var previewImage: UIImageView!
    // MARK: - Properties
    private var currentGesture: UITapGestureRecognizer?
    let image = UIImage(systemName: "square.and.arrow.up.fill")
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        shareButton.setBackgroundImage(image, for: .normal)
        setupImageSelection()
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure image views
        [firstImageView, secondImageView].forEach { imageView in
            imageView?.contentMode = .scaleAspectFit
            imageView?.clipsToBounds = true
            imageView?.backgroundColor = .systemGray6
            imageView?.layer.cornerRadius = 8
        }
        
        // Configure share button
        shareButton.layer.cornerRadius = 8
        shareButton.backgroundColor = .systemBackground
    }
    
    private func setupImageSelection() {
        // Add tap gesture recognizers to both image views
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        
        firstImageView.isUserInteractionEnabled = true
        secondImageView.isUserInteractionEnabled = true
        
        firstImageView.addGestureRecognizer(tapGesture1)
        secondImageView.addGestureRecognizer(tapGesture2)
    }
    
    // MARK: - Button Actions
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        handleShareButtonTapped()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func handleShareButtonTapped() {
        guard let image = previewImage.image else {
            showAlert(title: "Error", message: "No image to share.")
            return
        }
        
        // Set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // Exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, .postToFacebook]
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    // MARK: - Image Selection
    @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        currentGesture = gesture
        
        let actionSheet = UIAlertController(title: "Select Photo",
                                          message: "Choose a source",
                                          preferredStyle: .actionSheet)
        
        // Camera action
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            })
        }
        
        // Photo Library action
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        })
        
        // Cancel action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad support
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VitonPreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        // Determine which image view was tapped
        if let gesture = currentGesture,
           let tappedImageView = gesture.view as? UIImageView {
            tappedImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}



