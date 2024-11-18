import UIKit

// Updated MeasurePreviewViewController to display ML model output and present the measurement sheet
class MeasurePreviewViewController: UIViewController {
    
    var fetchedMeasurements: BodyMeasurement? // This will hold the fetched data
    @IBOutlet weak var imageView: UIImageView!
    var processedImage: UIImage?  // Image processed by the ML model


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging: Check if fetchedMeasurements is nil
        if let measurements = fetchedMeasurements {
            print("Fetched measurements: \(measurements)") // Debug print
            // Initialize processedImage from fetchedMeasurements if available
            processedImage = UIImage(named: measurements.processedImage ?? "placeholderImage")
        } else {
            print("No fetched measurements available.") // Debug print
            processedImage = UIImage(named: "placeholderImage") // Set placeholder if nil
        }
        
        setupNavigationItems()
//        displayProcessedImage()  // Display the processed image first
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure the view is fully loaded before presenting the next view controller
        presentMeasurementSheet()  // Present the measurement sheet
    }
    
    // Method to display the processed image
//    private func displayProcessedImage() {
//        if let image = processedImage {
//            imageView.image = image
//        } else {
//            // Handle case where no image is provided
//            imageView.image = UIImage(named: "dress1")  // Use a placeholder image if needed
//        }
//        
//        imageView.contentMode = .scaleAspectFit  // or .scaleAspectFill based on your needs
//        imageView.clipsToBounds = true
//    }
    
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
        // Dismiss both this view controller and any presented view controller
        presentedViewController?.dismiss(animated: false) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    // Action for Add button
    @objc private func addButtonTapped() {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.performSegue(withIdentifier: "savePage", sender: self)
            }
        }
    }
}
