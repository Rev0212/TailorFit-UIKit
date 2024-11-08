import UIKit

//class PreviewViewController: UIViewController {
//    
//    @IBOutlet weak var imageView: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigationItems() // Set up navigation items
//        presentMeasurementSheet() // Present the MeasurementViewController
//    }
//    
//    private func setupNavigationItems() {
//        // Set up the left navigation item (Cancel)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
//        
//        // Set up the right navigation item (+)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
//    }
//
//    private func presentMeasurementSheet() {
//        // Instantiate MeasurementViewController from storyboard
//        if let measurementVC = storyboard?.instantiateViewController(withIdentifier: "MeasurementViewController") as? MeasurementViewController {
//            measurementVC.modalPresentationStyle = .pageSheet // Change to .fullScreen if needed
//            
//            // Set up the navigation item for MeasurementViewController
//            measurementVC.isModalInPresentation = true // Disable swipe-to-dismiss
//            
//            // Set sheet properties for MeasurementViewController
//            if let sheet = measurementVC.sheetPresentationController {
//                sheet.detents = [.medium(), .large()]
//            }
//            
//            present(measurementVC, animated: true)
//        } else {
//            print("MeasurementViewController not found in storyboard.")
//        }
//    }
//
//    @objc private func cancelButtonTapped() {
//        // Handle cancel action
//        // Dismiss PreviewViewController or handle accordingly
//        
//    }
//
//    @objc private func addButtonTapped() {
//        // Dismiss the presented MeasurementViewController if it is currently presented
//        if let presentedVC = presentedViewController {
//            presentedVC.dismiss(animated: true) // Dismiss the sheet without completion
//        }
//        
//        // Perform the segue immediately after dismissing
//        performSegue(withIdentifier: "savePage", sender: self)
//    }
//}

import UIKit

class MeasurePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var capturedImage: UIImage? // Property to hold the captured image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        displayCapturedImage() // Display the image first
        presentMeasurementSheet()
    }
    
    private func displayCapturedImage() {
        // Set the captured image to the imageView
        imageView.image = capturedImage
        
        // Optional: Configure imageView properties
        imageView.contentMode = .scaleAspectFit // or .scaleAspectFill based on your needs
        imageView.clipsToBounds = true
    }
    
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
    
    @objc private func cancelButtonTapped() {
        // Dismiss both this view controller and any presented view controller
        presentedViewController?.dismiss(animated: false) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func addButtonTapped() {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.performSegue(withIdentifier: "savePage", sender: self)
            }
        }
    }
}
