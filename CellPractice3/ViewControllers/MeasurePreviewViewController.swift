//
//  MeasurePreviewViewController.swift
//  CellPractice3
//
//  Created by admin29 on 05/11/24.
//

import UIKit

// Updated MeasurePreviewViewController to display ML model output and present the measurement sheet
class MeasurePreviewViewController: UIViewController {
    
    var fetchedMeasurements: BodyMeasurement? // This will hold the fetched data
    @IBOutlet weak var imageView: UIImageView!
    var processedImage: String? // Processed image as a string from API call

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging: Check if fetchedMeasurements is nil
        if let measurements = fetchedMeasurements {
            print("Fetched measurements: \(measurements)") // Debug print
            processedImage = measurements.processedImage // Extract processedImage string
        } else {
            print("No fetched measurements available.") // Debug print
            processedImage = nil // Set to nil if no data is fetched
        }
        
        setupNavigationItems()
        displayProcessedImage()  // Display the processed image first
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure the view is fully loaded before presenting the next view controller
        presentMeasurementSheet()  // Present the measurement sheet
    }
    
    // Method to display the processed image
    func displayProcessedImage() {
        guard let imageView = imageView else {
            print("imageView is nil")
            return
        }
        
        // Load image from processedImage string
        if let imageNameOrURL = processedImage {
            if let image = UIImage(named: imageNameOrURL) { // Check if it's a local image name
                imageView.image = image
            } else if let url = URL(string: imageNameOrURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageView.image = image // Load image from URL
            } else {
                print("Invalid image name or URL: \(imageNameOrURL)")
                imageView.image = UIImage(named: "placeholderImage") // Placeholder for invalid or missing images
            }
        } else {
            print("No processed image available")
            imageView.image = UIImage(named: "placeholderImage")
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    // Method to set up navigation items
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    // Method to present the InstructionViewController sheet
    private func presentMeasurementSheet() {
        guard let measurementVC = storyboard?.instantiateViewController(withIdentifier: "MeasurementViewController") as? MeasurementViewController else {
            print("MeasurementViewController not found in storyboard.")
            return
        }
        
        // Pass data to the modal sheet
        measurementVC.fetchedMeasurements = fetchedMeasurements
        
        // Configure the modal presentation style
        measurementVC.modalPresentationStyle = .pageSheet  // You can try .formSheet if .pageSheet doesn't work
        
        // Optional: Check for devices that may not support sheet detents
        if let sheet = measurementVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        
        present(measurementVC, animated: true, completion: nil)
    }

    // Action for Cancel button
    @objc private func cancelButtonTapped() {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.dismiss(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    // Action for Add button
    @objc private func addButtonTapped() {
        presentedViewController?.dismiss(animated: true) {
            self.performSegue(withIdentifier: "savePage", sender: self)
        }
    }
}
