//
//  VitonPreviewViewController.swift
//  CellPractice3
//
//  Created by admin29 on 05/11/24.
//

import UIKit

class VitonPreviewViewController: UIViewController {
    
    // MARK: - Properties
    var receivedPhoto: UIImage?
    var receivedApparel: UIImage?
    var receivedResultImageURL: URL?
    var resultImageURL: URL?
    
    @IBOutlet weak var selectedPhoto: UIImageView!
    @IBOutlet weak var selectedApparel: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var regenerateButton: UIButton!
    
    private var currentGesture: UITapGestureRecognizer?
    let shareIcon = UIImage(systemName: "square.and.arrow.up.fill")
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        shareButton.setBackgroundImage(shareIcon, for: .normal)
        setupImageSelection()
        loadReceivedImages()
        loadImageFromURL()
    }
    
    // MARK: - Load Image from URL
    private func loadImageFromURL() {
            
            print(receivedResultImageURL)
            guard let url = receivedResultImageURL else {
                showAlert(title: "Error", message: "No image URL provided.")
                return
            }

            // Start downloading the image asynchronously
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                // Handle errors
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Failed to download image: \(error.localizedDescription)")
                    }
                    return
                }
                
                // Check for valid data and create the image
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.previewImage.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Failed to convert data to image.")
                    }
                }
            }
            
            task.resume() // Start the task
        }

    private func loadRegeneratedImageFromURL() {
        // Ensure the URL string from the response is valid
        print(resultImageURL)
        guard let urlString = resultImageURL?.absoluteString,
              let url = URL(string: urlString) else {
            showAlert(title: "Error", message: "Invalid image URL.")
            return
        }
        
        // Start downloading the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Handle errors
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to download image: \(error.localizedDescription)")
                }
                return
            }
            
            // Check for valid data and create the image
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.previewImage.image = image // Set the image in the UIImageView
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to convert data to image.")
                }
            }
        }
        
        task.resume() // Start the task to download the image
    }




    // MARK: - UI Setup
    private func setupUI() {
        // Configure image views
        [selectedPhoto, selectedApparel].forEach { imageView in
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
        
        selectedPhoto.isUserInteractionEnabled = true
        selectedApparel.isUserInteractionEnabled = true
        
        selectedPhoto.addGestureRecognizer(tapGesture1)
        selectedApparel.addGestureRecognizer(tapGesture2)
    }
    
    private func loadReceivedImages() {
        if let photo = receivedPhoto {
            selectedPhoto.image = photo
            selectedPhoto.backgroundColor = .clear
        } else {
            selectedPhoto.image = nil
            selectedPhoto.backgroundColor = .systemRed
        }
        
        if let apparel = receivedApparel {
            selectedApparel.image = apparel
            selectedApparel.backgroundColor = .clear
        } else {
            selectedApparel.image = nil
            selectedApparel.backgroundColor = .systemGreen
        }
    }
    
    // MARK: - Button Actions
    @IBAction func shareButtonTapped(_ sender: Any) {
        handleShareButtonTapped()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func regenerateBtnTapped(_ sender: UIButton) {
        guard let personImage = selectedPhoto.image,
              let garmentImage = selectedApparel.image else {
            showAlert(title: "Error", message: "Both person and garment images are required.")
            return
        }

        // Show loading animation
        let loadingView = LoadingAnimationView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(loadingView)

        // Create TryOnService instance
        let tryOnService = TryOnService()

        // Perform try-on request
        tryOnService.performTryOn(
            personImage: personImage,
            garmentImage: garmentImage,
            garmentDescription: "Virtual try-on garment"
        ) { [weak self] result in
            DispatchQueue.main.async {
                // Remove loading animation
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()

                switch result {
                case .success(let response):
                    // Use response.resultImage directly
                    if let resultImageURL = URL(string: "https://krp5b4mh-8000.inc1.devtunnels.ms"+response.resultImage) {
                        self?.resultImageURL =resultImageURL
                        self?.loadRegeneratedImageFromURL()
                    } else {
                        self?.showAlert(title: "Error", message: "Failed to parse the image URL.")
                    }
                case .failure(let error):
                    // Handle failure case
                    self?.showAlert(title: "Error", message: "Regenerate failed: \(error.localizedDescription)")
                }
            }
        }
    }




    
    private func handleShareButtonTapped() {
        guard let image = previewImage.image else {
            showAlert(title: "Error", message: "No image to share.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, .postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Image Selection
    @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        currentGesture = gesture
        
        let actionSheet = UIAlertController(title: "Select Photo",
                                            message: "Choose a source",
                                            preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
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
