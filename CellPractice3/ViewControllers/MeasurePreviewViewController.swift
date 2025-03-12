//
//  MeasurePreviewViewController.swift
//  CellPractice3
//
//  Created by admin29 on 05/11/24.
//

import UIKit

class MeasurePreviewViewController: UIViewController {
    
    var fetchedMeasurements: BodyMeasurement? // This will hold the fetched data
    @IBOutlet weak var imageView: UIImageView!
    var processedImageUrl: URL? // Processed image as a string from API call

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging: Check if fetchedMeasurements is nil
        if let measurements = fetchedMeasurements {
            print("Fetched measurements: \(measurements)") // Debug print
        } else {
            print("No fetched measurements available.") // Debug print
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
        
        // Check if the processedImage URL exists in the response
        if let processedImageURLString = fetchedMeasurements?.processedImage {
            // Replace "http://localhost:" with the new base URL
            let updatedImageURLString = processedImageURLString.replacingOccurrences(of: "http://localhost:7000",with: "https://m2b88tlh-8000.inc1.devtunnels.ms")
            print("Updated Image URL: \(updatedImageURLString)") // Debug
            
            if let imageUrl = URL(string: updatedImageURLString) {
                // Asynchronously load the image
                let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                            imageView.contentMode = .scaleAspectFit
                            imageView.clipsToBounds = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Error: Unable to convert data to UIImage")
                        }
                    }
                }
                task.resume()
            } else {
                print("Error: Invalid image URL after replacement")
            }
        } else {
            print("Invalid or missing processedImage in fetchedMeasurements")
            // Display placeholder
            imageView.image = UIImage(named: "placeholderImage")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savePage" {
            if let destinationVC = segue.destination as? MeasurementSaveViewController {
                // Pass the fetchedMeasurements data
                destinationVC.fetchedMeasurements = fetchedMeasurements
            }
        }
    }
    
    // Action for Add button
    @objc private func addButtonTapped() {
        presentedViewController?.dismiss(animated: true) {
            self.performSegue(withIdentifier: "savePage", sender: self)
        }
    }
}
