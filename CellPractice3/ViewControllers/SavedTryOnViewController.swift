//
//  SavedTryOn.swift
//  CellPractice3
//
//  Created by admin29 on 11/03/25.
//

import UIKit
import SwiftData

// MARK: - SavedTryOnViewController
class SavedTryOnViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var savedTryOns: [SavedTryOn] = []
    private var collectionView: UICollectionView!
    private let cellPadding: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Try-Ons"
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        loadTestImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add select button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
    }
    
    @objc private func selectButtonTapped() {
        // Toggle selection mode
        collectionView.allowsMultipleSelection = true
        
        // Change navigation items for selection mode
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSelection))
        
        // Add toolbar with actions
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelected))
        deleteButton.tintColor = .systemRed
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [deleteButton, flexSpace]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc private func cancelSelection() {
        // Reset UI to normal state
        collectionView.allowsMultipleSelection = false
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                cell.isInSelectionMode = false
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc private func deleteSelected() {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems, !selectedIndexPaths.isEmpty else { return }
        
        // Confirm deletion
        let alert = UIAlertController(
            title: "Delete \(selectedIndexPaths.count) Items?",
            message: "Are you sure you want to delete these items?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.performDeletion(at: selectedIndexPaths)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func performDeletion(at indexPaths: [IndexPath]) {
        // Sort in descending order to avoid index shifting issues
        let sortedIndexPaths = indexPaths.sorted { $0.item > $1.item }
        
        for indexPath in sortedIndexPaths {
            savedTryOns.remove(at: indexPath.item)
        }
        
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: indexPaths)
        }) { [weak self] _ in
            self?.cancelSelection()
        }
    }

    // MARK: - Setup CollectionView
    private func setupCollectionView() {
        // Create a compositional layout with 3 images per row
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsMultipleSelection = false
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Create a layout with 3 items per row
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: self.cellPadding,
                leading: self.cellPadding,
                bottom: self.cellPadding,
                trailing: self.cellPadding
            )
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/3)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }

    // MARK: - Load Test Images
    private func loadTestImages() {
        // Create test images using system icons
        let testImages = [
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
            UIImage(named: "dress1")!,
            UIImage(named: "dress2")!,
        ]

        // Convert images to Data and create SavedTryOn objects
        savedTryOns = testImages.compactMap { image in
            if let imageData = image.pngData() {
                return SavedTryOn(imageData: imageData, timestamp: Date())
            }
            return nil
        }

        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedTryOns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let image = UIImage(data: savedTryOns[indexPath.item].imageData) {
            cell.configure(with: image)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            // Selection mode
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                cell.isInSelectionMode = true
                cell.isSelected = true
            }
        } else {
            // Normal mode - open detail view
            collectionView.deselectItem(at: indexPath, animated: true)
            presentDetailView(for: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            if collectionView.allowsMultipleSelection {
                cell.isSelected = false
            }
        }
    }
    
    // MARK: - Present Detail View
    private func presentDetailView(for index: Int) {
        guard let image = UIImage(data: savedTryOns[index].imageData) else { return }
        
        let detailVC = ImageDetailViewController(image: image, index: index)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ImageDetailViewControllerDelegate
protocol ImageDetailViewControllerDelegate: AnyObject {
    func didDeleteImage(at index: Int)
    func didLikeImage(at index: Int)
}


// MARK: - UIScrollViewDelegate

// MARK: - SavedTryOnViewController Delegate
extension SavedTryOnViewController: ImageDetailViewControllerDelegate {
    func didDeleteImage(at index: Int) {
        savedTryOns.remove(at: index)
        collectionView.reloadData()
    }
    
    func didLikeImage(at index: Int) {
        // Handle like action (e.g., update the model)
        print("Liked image at index \(index)")
    }
}
