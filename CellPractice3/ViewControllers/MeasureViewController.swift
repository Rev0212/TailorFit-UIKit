import UIKit

class MeasureViewController: UIViewController {
    
    @IBOutlet weak var instructionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInstructionButton()
    }
    
    private func setupInstructionButton() {
        // You can add any setup for the instruction button if needed.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func instructionBtn(_ sender: Any) {
        presentMeasurementSheet()
    }
    
    private func presentMeasurementSheet() {
        if let instructionsVC = storyboard?.instantiateViewController(withIdentifier: "InstructionsViewController") as? InstructionViewController {
            instructionsVC.title = "Instructions"
            
            // Enable large title display mode
            instructionsVC.navigationItem.largeTitleDisplayMode = .always
            
            let navController = UINavigationController(rootViewController: instructionsVC)
            
            // Enable large titles in the navigation controller
            navController.navigationBar.prefersLargeTitles = true
            
            // Add a cancel button to the navigation bar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
            instructionsVC.navigationItem.rightBarButtonItem = doneButton
            
            // Set the modal presentation style for the sheet
            navController.modalPresentationStyle = .formSheet
            navController.isModalInPresentation = true
            
            // Configure the sheet presentation
            if let sheet = navController.sheetPresentationController {
                sheet.detents = [.large()]  // Adjust the detents as needed
            }
            
            // Present the sheet
            present(navController, animated: true)
        } else {
            print("InstructionsViewController not found in storyboard.")
        }
    }

    @objc private func doneButtonTapped() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

