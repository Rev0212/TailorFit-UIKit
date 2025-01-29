import UIKit

class VirtualTryOnViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Arrays to store all available images
    private var photoImages: [UIImage] = [UIImage(named: "person1")!, UIImage(named: "person2")!]
       private var apparelImages: [UIImage] = [UIImage(named: "dress4")!, UIImage(named: "dress2")!, UIImage(named: "dress3")!]
    // Variables to track selected images
    private var selectedPhotoIndex: Int?
    private var selectedApparelIndex: Int?
    
    
    private var resultImageURL: String?
    
    // UI Elements
    private var photoTitleLabel: UILabel!
    private var apparelTitleLabel: UILabel!
    private var photoCollectionView: UICollectionView!
    private var apprealCollectionView: UICollectionView!
    private var generateBtn: GenerateButton!
    
    // Dynamic height constraint for the apparel collection view
    private var apparelCollectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateApparelCollectionViewHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the titles
        setupTitles()
        
        // Set up the collection views
        setupCollectionViews()
        
        // Set up the generate button
        setupGenerateButton()
        
        
        // Add the UI elements to the view
        addSubviews()
        
        // Set up constraints
        setupConstraints()
    }
    
    private func setupTitles() {
        photoTitleLabel = UILabel()
        photoTitleLabel.text = "Choose a Picture of Yourself"
        photoTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        photoTitleLabel.textColor = .black
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        apparelTitleLabel = UILabel()
        apparelTitleLabel.text = "Choose Your Outfit"
        apparelTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        apparelTitleLabel.textColor = .black
        apparelTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionViews() {
        // Set up the photo collection view
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .horizontal
        photoLayout.itemSize = CGSize(width: 100, height: 100)
        photoLayout.minimumInteritemSpacing = 10
        photoLayout.minimumLineSpacing = 10
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: photoLayout)
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.allowsSelection = true
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the apparel collection view
        let apparelLayout = UICollectionViewFlowLayout()
        apparelLayout.scrollDirection = .vertical

        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing - 32) / itemsPerRow
        let itemHeight: CGFloat = itemWidth * 1.5

        apparelLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        apparelLayout.minimumInteritemSpacing = spacing
        apparelLayout.minimumLineSpacing = spacing

        apprealCollectionView = UICollectionView(frame: .zero, collectionViewLayout: apparelLayout)
        apprealCollectionView.register(ApparelCollectionViewCell.self, forCellWithReuseIdentifier: "ApparelCell")
        apprealCollectionView.dataSource = self
        apprealCollectionView.delegate = self
        apprealCollectionView.allowsSelection = true
        apprealCollectionView.backgroundColor = .clear
        apprealCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateApparelCollectionViewHeight() {
        let itemsPerRow: CGFloat = 4 // Number of items per row
        let spacing: CGFloat = 10 // Spacing between items
        let totalSpacing = (itemsPerRow - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing - 32) / itemsPerRow
        let itemHeight: CGFloat = itemWidth * 1.5 // Adjust proportionally (1.5x width)

        // Calculate the number of rows based on the item count
        let numberOfItems = collectionView(apprealCollectionView, numberOfItemsInSection: 0)
        let numberOfRows = ceil(CGFloat(numberOfItems) / itemsPerRow)

        // Calculate total height for the collection view
        let totalHeight = (numberOfRows * itemHeight) + ((numberOfRows - 1) * spacing)

        // Set a maximum height for 3 rows
        let maximumHeight: CGFloat = (2 * itemHeight) + (2 * spacing)

        // Update the height constraint dynamically with a maximum height
        apparelCollectionViewHeightConstraint.constant = min(totalHeight, maximumHeight)

        // Animate the layout change
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    private func reloadApparelCollectionView() {
        apprealCollectionView.reloadData()
        updateApparelCollectionViewHeight()
    }
    
    private func setupGenerateButton() {
            // Initialize the custom GenerateButton
        generateBtn = GenerateButton(type: .system)
            
            // Initially disable the button
            generateBtn.isEnabled = false
            generateBtn.alpha = 0.5
            
            // Disable autoresizing mask translation
            generateBtn.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the button to the view
            view.addSubview(generateBtn)
        
            NSLayoutConstraint.activate([
                generateBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                generateBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                generateBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])

            
            
            // Add the target action for button tap
            generateBtn.addTarget(self, action: #selector(testLoadingAnimation), for: .touchUpInside)
        }
    
    private func addSubviews() {
        view.addSubview(photoTitleLabel)
        view.addSubview(photoCollectionView)
        view.addSubview(apparelTitleLabel)
        view.addSubview(apprealCollectionView)
    }
    
    private func setupConstraints() {
        apparelCollectionViewHeightConstraint = apprealCollectionView.heightAnchor.constraint(equalToConstant: 300) // Default height
        NSLayoutConstraint.activate([
            // Apparel title label constraints
            apparelTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            apparelTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            apparelTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Apparel collection view constraints
            apprealCollectionView.topAnchor.constraint(equalTo: apparelTitleLabel.bottomAnchor, constant: 10),
            apprealCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            apprealCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            apparelCollectionViewHeightConstraint, // Dynamic height constraint

            // Photo title label constraints
            photoTitleLabel.topAnchor.constraint(equalTo: apprealCollectionView.bottomAnchor, constant: 40),
            photoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Photo collection view constraints
            photoCollectionView.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: 10),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 120),

        
        ])
    }

    private func updateGenerateButtonState() {
        let isEnabled = selectedPhotoIndex != nil && selectedApparelIndex != nil
        generateBtn.isEnabled = isEnabled
        generateBtn.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return photoImages.count + 1
        } else {
            return apparelImages.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            configureCell(cell, forItemAt: indexPath, isPhotoCell: true, isSelected: selectedPhotoIndex == indexPath.row )
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApparelCell", for: indexPath) as! ApparelCollectionViewCell
            configureCell(cell, forItemAt: indexPath, isPhotoCell: false, isSelected: selectedApparelIndex == indexPath.row)
        
            return cell
        }
    }
    
    private func configureCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, isPhotoCell: Bool, isSelected: Bool) {
        // Clear existing subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Determine if the current cell is the last cell
        let isLastCell = indexPath.row == (isPhotoCell ? photoImages.count : apparelImages.count)
        
        if isLastCell {
            // Button cell configuration
            let button = UIButton(type: .system)
            button.setTitle("+", for: .normal)
            button.frame = CGRect(x: 10, y: cell.bounds.height / 2 - 15, width: cell.bounds.width - 20, height: 40)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            button.layer.cornerRadius = 10
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.addTarget(self, action: isPhotoCell ? #selector(photoButtonTapped) : #selector(apparelButtonTapped), for: .touchUpInside)
            cell.contentView.addSubview(button)
        } else {
            // Image cell configuration
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = isPhotoCell ? photoImages[indexPath.row] : apparelImages[indexPath.row]
            cell.contentView.addSubview(imageView)
            
            // Add checkmark if selected
            if isSelected {
                addCheckmark(to: cell.contentView)
            }
        }
    }
    
    private func addCheckmark(to view: UIView) {
        let circleSize: CGFloat = 24
        let padding: CGFloat = 8
        let circleView = UIView(frame: CGRect(x: view.bounds.width - circleSize - padding,
                                              y: padding,
                                              width: circleSize,
                                              height: circleSize))
        circleView.backgroundColor = UIColor.systemGreen
        circleView.layer.cornerRadius = circleSize / 2
        view.addSubview(circleView)
        
        let checkmark = UIImageView(frame: circleView.bounds.insetBy(dx: 6, dy: 6))
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        checkmark.image = UIImage(systemName: "checkmark", withConfiguration: config)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        checkmark.contentMode = .scaleAspectFit
        circleView.addSubview(checkmark)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photoCollectionView {
            selectedPhotoIndex = (selectedPhotoIndex == indexPath.row) ? nil : indexPath.row 
            photoCollectionView.reloadData()
        } else {
            selectedApparelIndex = (selectedApparelIndex == indexPath.row ) ? nil : indexPath.row
            apprealCollectionView.reloadData()
        }
        updateGenerateButtonState()
    }
    
    @objc func photoButtonTapped() {
        showImagePickerOptions(for: .photo)
    }
    
    @objc func apparelButtonTapped() {
        showImagePickerOptions(for: .apparel)
    }
    
    private func showImagePickerOptions(for source: PickerSource) {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera, for: source)
        })
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary, for: source)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType, for source: PickerSource) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type \(sourceType) is not available")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        picker.view.tag = (source == .photo) ? 0 : 1
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            if picker.view.tag == 0 {
                photoImages.append(selectedImage)
                photoCollectionView.reloadData()
            } else {
                apparelImages.append(selectedImage)
                reloadApparelCollectionView() // Update height dynamically
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    enum PickerSource {
        case photo, apparel
    }
    
    // MARK: - Generate Button Action
    @objc func generateButtonTapped() {
        guard let photoIndex = selectedPhotoIndex,
              let apparelIndex = selectedApparelIndex else {
            print("Both a photo and an apparel must be selected to proceed.")
            return
        }
        
        let selectedPhoto = photoImages[photoIndex]
        let selectedApparel = apparelImages[apparelIndex]
        
        // Create and show loading animation view
        let loadingView = LoadingAnimationView(frame: UIScreen.main.bounds,image1: selectedPhoto,image2: selectedApparel)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(loadingView)
        
        // Create TryOnService instance
        let tryOnService = TryOnService()
        
        // Perform try-on request
        tryOnService.performTryOn(
            personImage: selectedPhoto,
            garmentImage: selectedApparel,
            garmentDescription: "Virtual try-on garment"
        ) { [weak self] result in
            DispatchQueue.main.async {
                // Remove loading animation
        
                
                switch result {
                case .success(let response):
                    // Fetch result image (URL)
                    self?.resultImageURL = "https://k9f1d21k-8000.inc1.devtunnels.ms" + response.resultImage
                    
                    // Navigate to preview screen with the result image URL
                    let previewVC = VitonPreviewViewController()
                    previewVC.receivedPhoto = selectedPhoto
                    previewVC.receivedApparel = selectedApparel
                    if let url = URL(string: self?.resultImageURL ?? "") {
                        previewVC.receivedResultImageURL = url
                    }
                    self?.navigationController?.pushViewController(previewVC, animated: true)
                    
                case .failure(let error):
                    // Show error alert
                    self?.showError(message: "Failed to generate try-on image. Please try again.")
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    
    
}

// Delete Later

// Add this extension to your view controller
extension VirtualTryOnViewController {
    @objc func testLoadingAnimation() {
        guard let photoIndex = selectedPhotoIndex,
              let apparelIndex = selectedApparelIndex else {
            print("Both a photo and an apparel must be selected to proceed.")
            return
        }
        
        let selectedPhoto = photoImages[photoIndex]
        let selectedApparel = apparelImages[apparelIndex]
        
        // Create a dimming view
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.addSubview(dimmingView)
        
        // Create and show loading animation view
        let loadingView = LoadingAnimationView(frame: UIScreen.main.bounds,image1: selectedPhoto, image2: selectedApparel)
        view.addSubview(loadingView)

        // Simulate API delay with Timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 13.0) { [weak self] in
            loadingView.removeFromSuperview()
            dimmingView.removeFromSuperview()
            
            let previewVC = VitonPreviewViewController()
            previewVC.receivedPhoto = selectedPhoto
            previewVC.receivedApparel = selectedApparel
            
            if let dummyURL = URL(string: "https://example.com/dummy-result.jpg") {
                previewVC.receivedResultImageURL = dummyURL
            }
            
            self?.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
}


// Add this helper function to simulate random failures for testing error handling
extension VirtualTryOnViewController {
    @objc func testLoadingWithRandomResult() {
        guard let photoIndex = selectedPhotoIndex,
              let apparelIndex = selectedApparelIndex else {
            print("Both a photo and an apparel must be selected to proceed.")
            return
        }
        
        let selectedPhoto = photoImages[photoIndex]
        let selectedApparel = apparelImages[apparelIndex]
        
        let dimmingView = UIView(frame: view.bounds)
                dimmingView.backgroundColor = UIColor.white // Or any color you prefer
                view.addSubview(dimmingView)
        
        // Create and show loading animation view
        let animationView = LoadingAnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 300),image1:selectedPhoto,image2:selectedApparel)
        
        view.addSubview(animationView)
      
        
        // Simulate API delay with random success/failure
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 10...18)) { [weak self] in
            // Remove loading animation
 
            animationView.removeFromSuperview()
            
            // Randomly succeed or fail
            if Bool.random() {
                // Success case
                let previewVC = VitonPreviewViewController()
                previewVC.receivedPhoto = selectedPhoto
                previewVC.receivedApparel = selectedApparel
                if let dummyURL = URL(string: "https://example.com/dummy-result.jpg") {
                    previewVC.receivedResultImageURL = dummyURL
                }
                self?.navigationController?.pushViewController(previewVC, animated: true)
            } else {
                // Failure case
                self?.showError(message: "Failed to generate try-on image. Please try again.")
            }
        }
    }
}
