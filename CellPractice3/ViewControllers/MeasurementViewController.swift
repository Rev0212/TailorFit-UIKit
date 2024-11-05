import UIKit

class MeasurementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    // Current values for the input fields
    var sizeValues = ["Shirt": "XL", "Pant": "L"]
    var measurementValues = ["Height": "183", "Chest": "57", "Waist": "63"]
    
    var currentUnit: MeasurementUnit = .cm
    
    enum MeasurementUnit {
        case cm
        case inch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItems() // Set up navigation items
        isModalInPresentation = true // Disable swipe-to-dismiss
        setupDimmingBackground() // Set up dimming background
        setupRoundedCorners() // Set up rounded corners
    }
    
    private func setupUI() {
        // TableView setup
        tableView.register(DemoTableViewCell.nib(), forCellReuseIdentifier: DemoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func setupNavigationItems() {
        // Set up the left navigation item (Cancel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        // Set up the right navigation item (+)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupDimmingBackground() {
        if let sheet = self.sheetPresentationController {
            sheet.delegate = self // Set self as delegate
            sheet.largestUndimmedDetentIdentifier = .medium // Set the largest undimmed area
            view.backgroundColor = UIColor.clear // Make the view background clear
        }
    }
    
    private func setupRoundedCorners() {
        // Set the corner radius for the sheet view
        if let sheet = self.sheetPresentationController {
            sheet.delegate = self
            
            // Customizing the view appearance
            if let containerView = sheet.presentedView {
                
                containerView.layer.cornerRadius = 16 // Set desired corner radius
                containerView.layer.masksToBounds = true // Ensure subviews are clipped to bounds
            }
        }
    }
    
    // MARK: - TableView DataSource & Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return sizeValues.count
        case 1: return measurementValues.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGroupedBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        
        headerView.addSubview(titleLabel)
        
        switch section {
        case 0:
            titleLabel.text = "Size"
        case 1:
            titleLabel.text = "Measurements"
            
            // Add segmented control for measurements section
            let segmentedControl = UISegmentedControl(items: ["cm", "inch"])
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.selectedSegmentIndex = currentUnit == .cm ? 0 : 1
            segmentedControl.addTarget(self, action: #selector(unitChanged(_:)), for: .valueChanged)
            
            headerView.addSubview(segmentedControl)
            
            NSLayoutConstraint.activate([
                segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                segmentedControl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        default:
            break
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoTableViewCell.identifier, for: indexPath) as! DemoTableViewCell
        
        switch indexPath.section {
        case 0:
            let key = Array(sizeValues.keys)[indexPath.row]
            cell.configure(title: key, value: sizeValues[key] ?? "", style: .size)
        case 1:
            let key = Array(measurementValues.keys)[indexPath.row]
            cell.configure(title: key, value: measurementValues[key] ?? "", style: .measurement)
        default:
            break
        }
        
        return cell
    }
    
    @objc private func unitChanged(_ sender: UISegmentedControl) {
        currentUnit = sender.selectedSegmentIndex == 0 ? .cm : .inch
        convertMeasurements()
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    private func convertMeasurements() {
        for (key, value) in measurementValues {
            if let numValue = Double(value) {
                if currentUnit == .inch {
                    measurementValues[key] = String(format: "%.1f", numValue / 2.54)
                } else {
                    measurementValues[key] = String(format: "%.1f", numValue * 2.54)
                }
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        // Dismiss the MeasurementViewController
        dismiss(animated: true, completion: nil)
    }

    @objc private func addButtonTapped() {
        // Handle add action
        print("Add button tapped")
        // Implement the logic for adding a measurement or other functionality
    }
}

// MARK: - UISheetPresentationControllerDelegate

extension MeasurementViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Optional: Handle when the presentation controller is dismissed
    }
}

