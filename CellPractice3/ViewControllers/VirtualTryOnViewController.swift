//
//  VirtualTryOnViewController.swift
//  CellPractice3
//
//  Created by admin29 on 05/11/24.
//

import UIKit

class VirtualTryOnViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var apparel1: UIImageView!
    @IBOutlet weak var apparel2: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addApparelButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var selectedImageView: UIImageView?
    private var isSelectingPhoto = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure image views
        [photo1, photo2, apparel1, apparel2].forEach { imageView in
            imageView?.layer.cornerRadius = 8
            imageView?.clipsToBounds = true
            imageView?.backgroundColor = .systemGray6
        }
        
        // Configure buttons
        [addPhotoButton, addApparelButton].forEach { button in
            button?.layer.cornerRadius = 8
            button?.clipsToBounds = true
        }
        
        generateButton.layer.cornerRadius = 8
        setupButtonActions()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    // MARK: - Button Actions
    private func setupButtonActions() {
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        addApparelButton.addTarget(self, action: #selector(addApparelTapped), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addPhotoTapped() {
        isSelectingPhoto = true
        presentImageSourceOptions()
    }
    
    @objc private func addApparelTapped() {
        isSelectingPhoto = false
        presentImageSourceOptions()
    }
    
    @objc private func linkButtonTapped() {
        let alert = UIAlertController(title: "Enter Apparel Link", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Paste link here"
            textField.keyboardType = .URL
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let link = alert.textFields?.first?.text, !link.isEmpty else { return }
            self?.handleApparelLink(link)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    @objc private func generateButtonTapped() {
        // Implement generation logic
        print("Generate button tapped")
    }
    
    // MARK: - Helper Methods
    private func presentImageSourceOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.imagePicker.sourceType = .camera
            self?.present(self?.imagePicker ?? UIImagePickerController(), animated: true)

        }
        
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.imagePicker.sourceType = .photoLibrary
            self?.present(self?.imagePicker ?? UIImagePickerController(), animated: true)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func handleApparelLink(_ link: String) {
        // Implement apparel link handling logic
        print("Handling apparel link: \(link)")
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        if isSelectingPhoto {
            if photo1.image == nil {
                photo1.image = image
            } else {
                photo2.image = image
            }
        } else {
            if apparel1.image == nil {
                apparel1.image = image
            } else {
                apparel2.image = image
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
