import UIKit
import SwiftData

class VitonPreviewViewController: UIViewController {
    
    var context: ModelContext?

    // MARK: - Properties
    var receivedPhoto: UIImage?
    var receivedApparel: UIImage?
    var receivedResultImageURL: URL?
    var resultImageURL: URL?

    // Programmatic UI Elements
    private let pageTitleLabel = UILabel()
    private let shareButton = UIButton()
    private let previewImage = UIImageView()
    private let selectedPhoto = UIImageView()
    private let selectedApparel = UIImageView()
    private var regenerateButton = GenerateButton()
    private var currentGesture: UITapGestureRecognizer?
    private let shareIcon = UIImage(systemName: "square.and.arrow.up.fill")

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if context == nil {
                    let container = try! ModelContainer(for: SavedTryOn.self)
                    context = ModelContext(container)
                }
        regenerateButton = GenerateButton()
        setupUI()
        setupNavigationBar()
        loadReceivedImages()
        loadImageFromURL()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        // Configure pageTitleLabel
        pageTitleLabel.text = "Viton Preview"
        pageTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pageTitleLabel.textAlignment = .left

        // Configure shareButton
        shareButton.setImage(shareIcon, for: .normal)
        shareButton.tintColor = .systemBlue
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)

        // Configure previewImage
        previewImage.contentMode = .scaleAspectFit
        previewImage.clipsToBounds = true
        previewImage.backgroundColor = .white
        previewImage.layer.cornerRadius = 8

        // Configure selectedPhoto
        selectedPhoto.contentMode = .scaleAspectFit
        selectedPhoto.clipsToBounds = false  // Changed to false to allow shadow to be visible
        selectedPhoto.backgroundColor = .systemGray6
        selectedPhoto.layer.cornerRadius = 8
        selectedPhoto.isUserInteractionEnabled = true
        selectedPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))

        // Add shadow to selectedPhoto
        selectedPhoto.layer.shadowColor = UIColor.black.cgColor
        selectedPhoto.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectedPhoto.layer.shadowRadius = 4
        selectedPhoto.layer.shadowOpacity = 0.2

        // Configure selectedApparel
        selectedApparel.contentMode = .scaleAspectFit
        selectedApparel.clipsToBounds = false  // Changed to false to allow shadow to be visible
        selectedApparel.backgroundColor = .systemGray6
        selectedApparel.layer.cornerRadius = 8
        selectedApparel.isUserInteractionEnabled = true
        selectedApparel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))

        // Add shadow to selectedApparel
        selectedApparel.layer.shadowColor = UIColor.black.cgColor
        selectedApparel.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectedApparel.layer.shadowRadius = 4
        selectedApparel.layer.shadowOpacity = 0.2

        // Configure regenerateButton
        regenerateButton.addTarget(self, action: #selector(regenerateBtnTapped), for: .touchUpInside)

        // Configure saveBtn
    

        // Add subviews
        view.addSubview(pageTitleLabel)
        view.addSubview(shareButton)
        view.addSubview(previewImage)
        view.addSubview(selectedPhoto)
        view.addSubview(selectedApparel)
        view.addSubview(regenerateButton)
      

        // Set up constraints
        setupConstraints()
    }

    private func setupConstraints() {
        pageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        selectedPhoto.translatesAutoresizingMaskIntoConstraints = false
        selectedApparel.translatesAutoresizingMaskIntoConstraints = false
        regenerateButton.translatesAutoresizingMaskIntoConstraints = false
    

        NSLayoutConstraint.activate([
            // Top Row: pageTitleLabel and shareButton
            pageTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shareButton.leadingAnchor, constant: -16),

            shareButton.centerYAnchor.constraint(equalTo: pageTitleLabel.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 40),
            shareButton.heightAnchor.constraint(equalToConstant: 40),

            // Center: previewImage
            previewImage.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 20),
            previewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            previewImage.bottomAnchor.constraint(equalTo: selectedPhoto.topAnchor, constant: -20),

            // Bottom Row: selectedPhoto, selectedApparel, regenerateButton
            // Bottom Row: selectedPhoto, selectedApparel, regenerateButton
            selectedPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            selectedPhoto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectedPhoto.widthAnchor.constraint(equalToConstant: 60),
            selectedPhoto.heightAnchor.constraint(equalToConstant: 60),

            selectedApparel.leadingAnchor.constraint(equalTo: selectedPhoto.trailingAnchor, constant: 12),
            selectedApparel.bottomAnchor.constraint(equalTo: selectedPhoto.bottomAnchor),
            selectedApparel.widthAnchor.constraint(equalToConstant: 60),
            selectedApparel.heightAnchor.constraint(equalToConstant: 60),

            // Move regenerateButton closer to the right
            regenerateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            regenerateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            regenerateButton.heightAnchor.constraint(equalTo: selectedPhoto.heightAnchor, multiplier: 0.75),
            regenerateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),


        ])
    }
    
    @objc private func saveButtonTapped() {
            guard let image = previewImage.image else {
                showAlert(title: "Error", message: "No image to save.")
                return
            }

            // Convert UIImage to Data
            guard let imageData = image.pngData() else {
                showAlert(title: "Error", message: "Failed to convert image to data.")
                return
            }

            // Create a new SavedTryOn instance
            let savedTryOn = SavedTryOn(imageData: imageData, timestamp: Date())

            // Save the instance using SwiftData
            saveTryOn(savedTryOn)
        }

        private func saveTryOn(_ savedTryOn: SavedTryOn) {
            guard let context = context else {
                showAlert(title: "Error", message: "Context not available.")
                return
            }

            do {
                context.insert(savedTryOn)
                try context.save()
                showAlert(title: "Saved", message: "Image saved successfully.")
            } catch {
                showAlert(title: "Error", message: "Failed to save image: \(error.localizedDescription)")
            }
        }

    // MARK: - Load Images
    private func loadReceivedImages() {
        selectedPhoto.image = receivedPhoto ?? nil
        selectedPhoto.backgroundColor = receivedPhoto == nil ? .systemRed : .clear

        selectedApparel.image = receivedApparel ?? nil
        selectedApparel.backgroundColor = receivedApparel == nil ? .systemGreen : .clear
    }

    private func loadImageFromURL() {
        guard let url = receivedResultImageURL else {
            showAlert(title: "Error", message: "No image URL provided.")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to download image: \(error.localizedDescription)")
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.previewImage.image = image
                }
            }
        }.resume()
    }

    // MARK: - Button Actions
    @objc private func shareButtonTapped() {
        guard let image = previewImage.image else {
            showAlert(title: "Error", message: "No image to share.")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    @objc private func regenerateBtnTapped() {
        guard let personImage = selectedPhoto.image, let garmentImage = selectedApparel.image else {
            showAlert(title: "Error", message: "Both person and garment images are required.")
            return
        }

        // Show loading animation (you can implement this separately)
//        let loadingView = LoadingAnimationView(frame: UIScreen.main.bounds,image1: <#T##UIImage#>)
//        view.addSubview(loadingView)

        let tryOnService = TryOnService()
        tryOnService.performTryOn(
            personImage: personImage,
            garmentImage: garmentImage,
            garmentDescription: "Virtual try-on garment"
        ) { [weak self] result in
            DispatchQueue.main.async {
//                loadingView.removeFromSuperview()

                switch result {
                case .success(let response):
                    if let resultImageURL = URL(string: "https://1h0g231h-7000.inc1.devtunnels.ms" + response.resultImage) {
                        self?.resultImageURL = resultImageURL
                        self?.loadImageFromURL()
                    } else {
                        self?.showAlert(title: "Error", message: "Failed to parse the image URL.")
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: "Regenerate failed: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Image Selection
    @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        currentGesture = gesture
        presentImagePicker(sourceType: .photoLibrary)
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VitonPreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        if let gesture = currentGesture, let tappedImageView = gesture.view as? UIImageView {
            tappedImageView.image = selectedImage
            tappedImageView.backgroundColor = .clear
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
