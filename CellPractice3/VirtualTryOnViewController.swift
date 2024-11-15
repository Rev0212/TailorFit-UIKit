//
//  VirtualTryOnViewController.swift
//  CellPractice3
//
//  Created by admin29 on 15/11/24.
//

import UIKit

class VirtualTryOnViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var apprealCollectionView: UICollectionView!
    @IBOutlet weak var generateBtn: UIButton!
    
    // Arrays to store all available images
    private var photoImages: [UIImage] = [UIImage(named: "person1")!, UIImage(named: "person2")!]
    private var apparelImages: [UIImage] = [UIImage(named: "dress1")!, UIImage(named: "dress2")!, UIImage(named: "dress3")!]
    
    // Variables to track selected images
    private var selectedPhotoIndex: Int?
    private var selectedApparelIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViews()
        setupGenerateButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToVitonpreview",
           let destinationVC = segue.destination as? VitonPreviewViewController {
            if let photoIndex = selectedPhotoIndex {
                destinationVC.receivedPhoto = photoImages[photoIndex]
            }
            if let apparelIndex = selectedApparelIndex {
                destinationVC.receivedApparel = apparelImages[apparelIndex]
            }
        }
    }
    
    private func setupCollectionViews() {
        // Register the XIB files for collection view cells
        photoCollectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        apprealCollectionView.register(UINib(nibName: "ApprealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApparelCell")
        
        // Set up the horizontal layout for photoCollectionView
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .horizontal
        photoLayout.itemSize = CGSize(width: 100, height: 100)
        photoLayout.minimumInteritemSpacing = 10
        photoLayout.minimumLineSpacing = 10
        photoCollectionView.collectionViewLayout = photoLayout
        
        // Set up the grid layout for apprealCollectionView
        let apparelLayout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let itemWidth = (apprealCollectionView.bounds.width - totalSpacing) / itemsPerRow
        apparelLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        apparelLayout.minimumInteritemSpacing = spacing
        apparelLayout.minimumLineSpacing = spacing
        apprealCollectionView.collectionViewLayout = apparelLayout
        
        // Set data sources and delegates
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        apprealCollectionView.dataSource = self
        apprealCollectionView.delegate = self
        
        // Enable selection
        photoCollectionView.allowsSelection = true
        apprealCollectionView.allowsSelection = true
    }
    
    private func setupGenerateButton() {
        generateBtn.isEnabled = false
        generateBtn.alpha = 0.5
        updateGenerateButtonState()
    }
    
    private func updateGenerateButtonState() {
        let isEnabled = selectedPhotoIndex != nil && selectedApparelIndex != nil
        generateBtn.isEnabled = isEnabled
        generateBtn.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return photoImages.count + 1 // +1 for the button cell
        } else {
            return apparelImages.count + 1 // +1 for the button cell
        }
    }
    
    
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          if collectionView == photoCollectionView {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
              configureCell(cell, forItemAt: indexPath, isPhotoCell: true, isSelected: selectedPhotoIndex == indexPath.row - 1)
              return cell
          } else {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApparelCell", for: indexPath) as! ApprealCollectionViewCell
              configureCell(cell, forItemAt: indexPath, isPhotoCell: false, isSelected: selectedApparelIndex == indexPath.row - 1)
              return cell
          }
      }
      
      private func configureCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, isPhotoCell: Bool, isSelected: Bool) {
          cell.contentView.subviews.forEach { $0.removeFromSuperview() }
          
          if indexPath.row == 0 {
              // Button cell configuration
              let button = UIButton(type: .system)
              button.setTitle("+", for: .normal)
              button.frame = CGRect(x: 10, y: cell.bounds.height / 2 - 15, width: cell.bounds.width - 20, height: 40)
              button.setTitleColor(.black, for: .normal)
              button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
              button.layer.cornerRadius = 10
              button.layer.shadowColor = UIColor.black.cgColor
              button.layer.shadowOpacity = 0.3
              button.layer.shadowOffset = CGSize(width: 2, height: 2)
              button.addTarget(self, action: isPhotoCell ? #selector(photoButtonTapped) : #selector(apparelButtonTapped), for: .touchUpInside)
              cell.contentView.addSubview(button)
          } else {
              // Image cell configuration
              let imageView = UIImageView(frame: cell.contentView.bounds)
              imageView.contentMode = .scaleAspectFill
              imageView.clipsToBounds = true
              imageView.image = isPhotoCell ? photoImages[indexPath.row - 1] : apparelImages[indexPath.row - 1]
              cell.contentView.addSubview(imageView)
              
              // Add checkmark if selected
              if isSelected {
                  addCheckmark(to: cell.contentView)
              }
          }
      }
      
      private func addCheckmark(to view: UIView) {
          // Create circular background
          let circleSize: CGFloat = 24
          let padding: CGFloat = 8
          
          let circleView = UIView(frame: CGRect(x: view.bounds.width - circleSize - padding,
                                              y: padding,
                                              width: circleSize,
                                              height: circleSize))
          circleView.backgroundColor = UIColor.systemGreen
          circleView.layer.cornerRadius = circleSize / 2
          view.addSubview(circleView)
          
          // Create checkmark
          let checkmark = UIImageView(frame: circleView.bounds.insetBy(dx: 6, dy: 6))
          let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
          checkmark.image = UIImage(systemName: "checkmark", withConfiguration: config)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
          checkmark.contentMode = .scaleAspectFit
          circleView.addSubview(checkmark)
      }
    
    private func configureCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, isPhotoCell: Bool) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        if indexPath.row == 0 {
            // Button cell
            let button = UIButton(type: .system)
            button.setTitle("+", for: .normal)
            button.frame = CGRect(x: 10, y: cell.bounds.height / 2 - 15, width: cell.bounds.width - 20, height: 40)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.addTarget(self, action: isPhotoCell ? #selector(photoButtonTapped) : #selector(apparelButtonTapped), for: .touchUpInside)
            cell.contentView.addSubview(button)
        } else {
            // Image cell
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = isPhotoCell ? photoImages[indexPath.row - 1] : apparelImages[indexPath.row - 1]
            cell.contentView.addSubview(imageView)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return } // Ignore selection of the "+" button cell
        
        if collectionView == photoCollectionView {
            // If tapping the currently selected photo, deselect it
            if selectedPhotoIndex == indexPath.row - 1 {
                selectedPhotoIndex = nil
            } else {
                selectedPhotoIndex = indexPath.row - 1
            }
            photoCollectionView.reloadData()
        } else {
            // If tapping the currently selected apparel, deselect it
            if selectedApparelIndex == indexPath.row - 1 {
                selectedApparelIndex = nil
            } else {
                selectedApparelIndex = indexPath.row - 1
            }
            apprealCollectionView.reloadData()
        }
        
        updateGenerateButtonState()
    }
    
    // MARK: - Image Picker Methods
    
    @objc func photoButtonTapped() {
        showImagePickerOptions(for: .photo)
    }
    
    @objc func apparelButtonTapped() {
        showImagePickerOptions(for: .apparel)
    }
    
    private enum PickerSource {
        case photo
        case apparel
    }
    
    private func showImagePickerOptions(for source: PickerSource) {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera, for: source)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary, for: source)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
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
        picker.view.tag = source == .photo ? 0 : 1
        
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            print("No image selected")
            return
        }
        
        if picker.view.tag == 0 {
            // Insert at the beginning of photoImages array
            photoImages.insert(image, at: 0)
            
            // Adjust selected photo index if one was previously selected
            if let currentIndex = selectedPhotoIndex {
                selectedPhotoIndex = currentIndex + 1
            }
            // Select the newly added photo
            selectedPhotoIndex = 0
            photoCollectionView.reloadData()
        } else {
            // Insert at the beginning of apparelImages array
            apparelImages.insert(image, at: 0)
            
            // Adjust selected apparel index if one was previously selected
            if let currentIndex = selectedApparelIndex {
                selectedApparelIndex = currentIndex + 1
            }
            // Select the newly added apparel
            selectedApparelIndex = 0
            apprealCollectionView.reloadData()
        }
        
        updateGenerateButtonState()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - Generate Button Action
    
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        guard let photoIndex = selectedPhotoIndex,
              let apparelIndex = selectedApparelIndex else {
            print("Both a photo and an apparel must be selected to proceed.")
            return
        }
        
        let selectedPhoto = photoImages[photoIndex]
        let selectedApparel = apparelImages[apparelIndex]
        
        performSegue(withIdentifier: "navigateToVitonPreview", sender: (selectedPhoto, selectedApparel))
        print("Generate Button Tapped")
}

    
}

