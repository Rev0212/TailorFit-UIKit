
import UIKit

// Updated MeasurePreviewViewController to display ML model output and present the measurement sheet
class MeasurePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var processedImage: UIImage?  // Image processed by the ML model
    var modelOutputDetails: String?  // String containing additional details from the model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        displayProcessedImage()  // Display the processed image first
        presentMeasurementSheet()  // Present the measurement sheet as before
    }
    
    // Method to display the processed image
    private func displayProcessedImage() {
        if let image = processedImage {
            imageView.image = image
        } else {
            // Handle case where no image is provided
            imageView.image = UIImage(named: "placeholderImage")  // Use a placeholder image if needed
        }
        
        imageView.contentMode = .scaleAspectFit  // or .scaleAspectFill based on your needs
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
    
    // Method to present the MeasurementViewController sheet
    private func presentMeasurementSheet() {
        if let measurementVC = storyboard?.instantiateViewController(withIdentifier: "MeasurementViewController") as? MeasurementViewController {
            measurementVC.modalPresentationStyle = .pageSheet
            measurementVC.isModalInPresentation = true
            
            if let sheet = measurementVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            
            present(measurementVC, animated: true)
        } else {
            print("MeasurementViewController not found in storyboard.")
        }
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
