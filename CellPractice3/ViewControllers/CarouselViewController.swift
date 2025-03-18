import UIKit

class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var photoImages: [UIImage] = [UIImage(named: "person1")!, UIImage(named: "person2")!]
    private var apparelImages: [UIImage] = [UIImage(named: "dress4")!, UIImage(named: "dress2")!, UIImage(named: "dress3")!]
    private var selectedPhotoIndex: Int?
    private var selectedApparelIndex: Int?
    
    private var photoCollectionView: UICollectionView!
    private var apparelCollectionView: UICollectionView!
    private var generateBtn: GenerateButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupGenerateButton()
        setupConstraints()
    }
    
    private func setupCollectionViews() {
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .horizontal
        photoLayout.itemSize = CGSize(width: 100, height: 100)
        photoLayout.minimumInteritemSpacing = 10
        photoLayout.minimumLineSpacing = 10
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: photoLayout)
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let apparelLayout = UICollectionViewFlowLayout()
        apparelLayout.scrollDirection = .horizontal
        apparelLayout.itemSize = CGSize(width: 100, height: 100)
        apparelLayout.minimumInteritemSpacing = 10
        apparelLayout.minimumLineSpacing = 10
        
        apparelCollectionView = UICollectionView(frame: .zero, collectionViewLayout: apparelLayout)
        apparelCollectionView.register(ApparelCollectionViewCell.self, forCellWithReuseIdentifier: "ApparelCell")
        apparelCollectionView.dataSource = self
        apparelCollectionView.delegate = self
        apparelCollectionView.backgroundColor = .clear
        apparelCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoCollectionView)
        view.addSubview(apparelCollectionView)
    }
    
    private func setupGenerateButton() {
        generateBtn = GenerateButton(type: .system)
        generateBtn.isEnabled = false
        generateBtn.alpha = 0.5
        generateBtn.translatesAutoresizingMaskIntoConstraints = false
        generateBtn.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        view.addSubview(generateBtn)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            apparelCollectionView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 20),
            apparelCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            apparelCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            apparelCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            generateBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            generateBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            generateBtn.heightAnchor.constraint(equalToConstant: 70),
            generateBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == photoCollectionView ? photoImages.count + 1 : apparelImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            configureCell(cell, forItemAt: indexPath, isPhotoCell: true, isSelected: selectedPhotoIndex == indexPath.row)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApparelCell", for: indexPath) as! ApparelCollectionViewCell
            configureCell(cell, forItemAt: indexPath, isPhotoCell: false, isSelected: selectedApparelIndex == indexPath.row)
            return cell
        }
    }
    
    private func configureCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, isPhotoCell: Bool, isSelected: Bool) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let isLastCell = indexPath.row == (isPhotoCell ? photoImages.count : apparelImages.count)
        
        if isLastCell {
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
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = isPhotoCell ? photoImages[indexPath.row] : apparelImages[indexPath.row]
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.systemGray2.cgColor
            cell.contentView.addSubview(imageView)
            
            if isSelected {
                addCheckmark(to: cell.contentView)
            }
        }
    }
    
    private func addCheckmark(to view: UIView) {
        let circleSize: CGFloat = 24
        let padding: CGFloat = 8
        let circleView = UIView(frame: CGRect(x: view.bounds.width - circleSize - padding, y: padding, width: circleSize, height: circleSize))
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
            selectedApparelIndex = (selectedApparelIndex == indexPath.row) ? nil : indexPath.row
            apparelCollectionView.reloadData()
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
                apparelCollectionView.reloadData()
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    private func updateGenerateButtonState() {
        let isEnabled = selectedPhotoIndex != nil && selectedApparelIndex != nil
        generateBtn.isEnabled = isEnabled
        generateBtn.alpha = isEnabled ? 1.0 : 0.5
    }
    
    @objc func generateButtonTapped() {
        guard let photoIndex = selectedPhotoIndex, let apparelIndex = selectedApparelIndex else {
            print("Both a photo and an apparel must be selected to proceed.")
            return
        }
        
        let selectedPhoto = photoImages[photoIndex]
        let selectedApparel = apparelImages[apparelIndex]
        
        // Proceed with the API call
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.addSubview(dimmingView)
        
        let loadingView = LoadingAnimationView(frame: UIScreen.main.bounds, image1: selectedPhoto, image2: selectedApparel)
        view.addSubview(loadingView)
        
        let tryOnService = TryOnService()
        tryOnService.performTryOn(personImage: selectedPhoto, garmentImage: selectedApparel, garmentDescription: "Virtual try-on garment") { [weak self] result in
            DispatchQueue.main.async {
                loadingView.removeFromSuperview()
                dimmingView.removeFromSuperview()
                
                switch result {
                case .success(let response):
                    self?.resultImageURL = "https://1h0g231h-7000.inc1.devtunnels.ms" + response.resultImage
                    let previewVC = VitonPreviewViewController()
                    previewVC.receivedPhoto = selectedPhoto
                    previewVC.receivedApparel = selectedApparel
                    if let url = URL(string: self?.resultImageURL ?? "") {
                        previewVC.receivedResultImageURL = url
                    }
                    self?.navigationController?.pushViewController(previewVC, animated: true)
                    
                case .failure(let error):
                    self?.showError(message: "Failed to generate try-on image. Please try again.")
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    enum PickerSource {
        case photo, apparel
    }
}