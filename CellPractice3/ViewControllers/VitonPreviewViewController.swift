import UIKit
import SwiftData

class VitonPreviewViewController: UIViewController {

    var context: ModelContext?

    // MARK: - Properties
    var receivedPhoto: UIImage?
    var receivedApparel: UIImage?
    var receivedResultImageURL: URL?
    var resultImageURL: URL?

    var currentGPUURL: String? {
        return NetworkManager.shared.gpuServerURL
    }

    private let pageTitleLabel = UILabel()
    private let shareButton = UIButton()
    private let previewImage = UIImageView()
    private let selectedPhoto = UIImageView()
    private let selectedApparel = UIImageView()
    private var regenerateButton = GenerateButton()
    private var currentGesture: UITapGestureRecognizer?
    private let shareIcon = UIImage(systemName: "square.and.arrow.up.fill")

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
        loadInitialImageFromReceivedURL() // 👈 Initial image load
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "TryOn Preview"
        navigationController?.navigationBar.prefersLargeTitles = false

//        pageTitleLabel.text = "Viton Preview"
//        pageTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        pageTitleLabel.textAlignment = .left

//        shareButton.setImage(shareIcon, for: .normal)
//        shareButton.tintColor = .systemBlue
//        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)

        previewImage.contentMode = .scaleAspectFill
        previewImage.clipsToBounds = true
        previewImage.backgroundColor = .white
        previewImage.layer.cornerRadius = 8

        selectedPhoto.contentMode = .scaleAspectFit
        selectedPhoto.clipsToBounds = false
        selectedPhoto.backgroundColor = .systemGray6
        selectedPhoto.layer.cornerRadius = 8
        selectedPhoto.isUserInteractionEnabled = true
        selectedPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        selectedPhoto.layer.shadowColor = UIColor.black.cgColor
        selectedPhoto.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectedPhoto.layer.shadowRadius = 4
        selectedPhoto.layer.shadowOpacity = 0.2

        selectedApparel.contentMode = .scaleAspectFill
        selectedApparel.clipsToBounds = false
        selectedApparel.backgroundColor = .systemGray6
        selectedApparel.layer.cornerRadius = 8
        selectedApparel.isUserInteractionEnabled = true
        selectedApparel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        selectedApparel.layer.shadowColor = UIColor.black.cgColor
        selectedApparel.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectedApparel.layer.shadowRadius = 4
        selectedApparel.layer.shadowOpacity = 0.2

        regenerateButton.addTarget(self, action: #selector(regenerateBtnTapped), for: .touchUpInside)

        view.addSubview(pageTitleLabel)
        view.addSubview(shareButton)
        view.addSubview(previewImage)
        view.addSubview(selectedPhoto)
        view.addSubview(selectedApparel)
        view.addSubview(regenerateButton)

        setupConstraints()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    
    private func setupConstraints() {
        [pageTitleLabel, shareButton, previewImage, selectedPhoto, selectedApparel, regenerateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // 🖼️ Preview image nicely placed near the top
            previewImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            previewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            previewImage.bottomAnchor.constraint(equalTo: selectedPhoto.topAnchor, constant: -32),
 // or 0.4 for a shorter preview

            // selected photo (left)
            selectedPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            selectedPhoto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectedPhoto.widthAnchor.constraint(equalToConstant: 80),
            selectedPhoto.heightAnchor.constraint(equalToConstant: 80),

            // elected apparel (next to photo)
            selectedApparel.leadingAnchor.constraint(equalTo: selectedPhoto.trailingAnchor, constant: 12),
            selectedApparel.bottomAnchor.constraint(equalTo: selectedPhoto.bottomAnchor),
            selectedApparel.widthAnchor.constraint(equalToConstant: 80),
            selectedApparel.heightAnchor.constraint(equalToConstant: 80),

            //regenerate button (right side)
            regenerateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            regenerateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            regenerateButton.heightAnchor.constraint(equalToConstant: 48),
            regenerateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }

    // MARK: - Image Loading
    private func loadInitialImageFromReceivedURL() {
        guard let url = receivedResultImageURL else {
            print("receivedResultImageURL is nil")
            showAlert(title: "Error", message: "No image URL provided.")
            return
        }

        print("Initial image load from: \(url)")
        loadImage(from: url)
    }

    private func loadGeneratedImageFromResultURL() {
        guard let url = resultImageURL else {
            print("resultImageURL is nil")
            showAlert(title: "Error", message: "No regenerated image URL.")
            return
        }

        print("Regenerated image URL: \(url)")
        loadImage(from: url)
    }

    private func loadImage(from url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        previewImage.image = nil
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        previewImage.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: previewImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: previewImage.centerYAnchor)
        ])
        activityIndicator.startAnimating()

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()

                if let error = error {
                    print("Failed to load image: \(error.localizedDescription)")
                    self?.showAlert(title: "Error", message: "Failed to download image.")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    self?.previewImage.image = image
                    UIView.transition(with: self?.previewImage ?? UIView(), duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                } else {
                    print("Invalid image data from: \(url)")
                    self?.showAlert(title: "Error", message: "Invalid image data.")
                }
            }
        }.resume()
    }

    // MARK: - Button Actions
    @objc private func regenerateBtnTapped() {
        guard let photoImage = selectedPhoto.image,
              let apparelImage = selectedApparel.image else {
            showAlert(title: "Error", message: "Both images are required.")
            return
        }

        let resizedPhoto = resizeImage(photoImage)
        let resizedApparel = resizeImage(apparelImage)

        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.addSubview(dimmingView)

        let loadingView = LoadingAnimationView(frame: UIScreen.main.bounds, image1: photoImage, image2: apparelImage)
        view.addSubview(loadingView)

        let tryOnService = TryOnService()
        tryOnService.performTryOn(personImage: resizedPhoto, garmentImage: resizedApparel, garmentDescription: "upper_body") { [weak self] result in
            DispatchQueue.main.async {
                loadingView.removeFromSuperview()
                dimmingView.removeFromSuperview()

                switch result {
                case .success(let response):
                    self?.stopFailureAnimation()
                    self?.resultImageURL = URL(string: (self?.currentGPUURL ?? "") + response.resultImage)
                    self?.loadGeneratedImageFromResultURL()
                case .failure:
                    self?.showAlert(title: "Error", message: "Something went wrong, try again later.")
                    self?.startFailureAnimation()
                }
            }
        }
    }

    @objc private func saveButtonTapped() {
        guard let resultImage = previewImage.image,
              let personImage = selectedPhoto.image,
              let apparelImage = selectedApparel.image,
              let mainData = personImage.pngData(),
              let apparelData = apparelImage.pngData(),
              let resultData = resultImage.pngData() else {
            showAlert(title: "Error", message: "Missing or invalid images.")
            return
        }

        let savedTryOn = SavedTryOn(
            mainImageData: mainData,
            apparelImageData: apparelData,
            resultImageData: resultData,
            timestamp: Date()
        )

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
            showAlert(title: "Error", message: "Save failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Helpers
    private func resizeImage(_ image: UIImage, to size: CGSize = CGSize(width: 768, height: 1024)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { _ in
            let aspectRatio = image.size.width / image.size.height
            let targetAspectRatio = size.width / size.height
            var rect = CGRect(origin: .zero, size: size)

            if aspectRatio > targetAspectRatio {
                let height = size.width / aspectRatio
                rect.origin.y = (size.height - height) / 2
                rect.size.height = height
            } else {
                let width = size.height * aspectRatio
                rect.origin.x = (size.width - width) / 2
                rect.size.width = width
            }

            image.draw(in: rect)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func startFailureAnimation() { /* unchanged */ }
    func stopFailureAnimation() { /* unchanged */ }

    private func loadReceivedImages() {
        selectedPhoto.image = receivedPhoto
        selectedApparel.image = receivedApparel

        selectedPhoto.backgroundColor = receivedPhoto == nil ? .systemRed : .clear
        selectedApparel.backgroundColor = receivedApparel == nil ? .systemGreen : .clear
    }

    @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        currentGesture = gesture
        presentImagePicker(sourceType: .photoLibrary)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    @objc private func shareButtonTapped() {
        guard let image = previewImage.image else {
            showAlert(title: "Error", message: "No image to share.")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

extension VitonPreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        if let gesture = currentGesture, let imageView = gesture.view as? UIImageView {
            imageView.image = selectedImage
            imageView.backgroundColor = .clear
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
