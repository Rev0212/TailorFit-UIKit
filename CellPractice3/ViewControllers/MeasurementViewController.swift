import UIKit

class MeasurementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISheetPresentationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var fetchedMeasurements: BodyMeasurement? // This will hold the fetched data
    
    var currentUnit: MeasurementUnit = .inch // Defaulting to inch, since data is in inches
    
    var sizeValues: [String: String] = [:]
    var measurementValues: [String: String] = [:]
    
    // Size charts (measurements in inches)
    private let shirtSizeChart: [(size: String, chest: ClosedRange<Double>)] = [
            ("XS", 33...35),
            ("S", 35.5...37.5),
            ("M", 38...40),
            ("L", 40.5...42.5),
            ("XL", 43...44.5),
            ("XXL", 45...47)
        ]
        
    private let pantSizeChart: [(size: String, waist: ClosedRange<Double>)] = [
        ("28", 28...29),
        ("30", 30...31),
        ("32", 32...33),
        ("34", 34...35),
        ("36", 36...37),
        ("38", 38...39),
        ("40", 40...41)
    ]
    
    enum MeasurementUnit {
        case cm
        case inch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItems() // Set up navigation items
        setupDimmingBackground() // Set up dimming background
        setupRoundedCorners() // Set up rounded corners
        mapMeasurementsToValues() // Map fetched measurements to table data
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
        if let sheet = self.sheetPresentationController {
            sheet.delegate = self
            if let containerView = sheet.presentedView {
                containerView.layer.cornerRadius = 16
                containerView.layer.masksToBounds = true
            }
        }
    }
    
    private func determineShirtSize(chestCircumference: Double) -> String {
        // No conversion needed since we are now using inches as the default unit
        for (size, range) in shirtSizeChart {
            if range.contains(chestCircumference) {
                return size
            }
        }
        if let firstSize = shirtSizeChart.first, chestCircumference < firstSize.chest.lowerBound {
            return "< \(firstSize.size)"
        }
        if let lastSize = shirtSizeChart.last, chestCircumference > lastSize.chest.upperBound {
            return "> \(lastSize.size)"
        }
        return "N/A"
    }
    
    private func determinePantSize(waistCircumference: Double) -> String {
        // No conversion needed since we are now using inches as the default unit
        for (size, range) in pantSizeChart {
            if range.contains(waistCircumference) {
                return size
            }
        }
        if let firstSize = pantSizeChart.first, waistCircumference < firstSize.waist.lowerBound {
            return "< \(firstSize.size)"
        }
        if let lastSize = pantSizeChart.last, waistCircumference > lastSize.waist.upperBound {
            return "> \(lastSize.size)"
        }
        return "N/A"
    }
    
    private func mapMeasurementsToValues() {
        guard let measurements = fetchedMeasurements else { return }
        
        // Map sizes based on measurements
        let shirtSize = determineShirtSize(chestCircumference: Double(measurements.chestCircumference ?? 0))
        let pantSize = determinePantSize(waistCircumference: Double(measurements.waistCircumference ?? 0))
        
        // Map sizeValues with determined sizes
        sizeValues = [
            "Pant": pantSize,
            "Shirt": shirtSize,
        ]
        
        // Map measurementValues
        measurementValues = [
            "Chest Circumference": formatMeasurement(Double(measurements.chestCircumference ?? 0)),
            "Waist Circumference": formatMeasurement(Double(measurements.waistCircumference ?? 0)),
            "Hip Circumference": formatMeasurement(Double(measurements.hipCircumference ?? 0)),
            "Left Bicep Circumference": formatMeasurement(Double(measurements.leftBicepCircumference ?? 0)),
            "Right Bicep Circumference": formatMeasurement(Double(measurements.rightBicepCircumference ?? 0)),
            "Left Thigh Circumference": formatMeasurement(Double(measurements.leftThighCircumference ?? 0)),
            "Right Thigh Circumference": formatMeasurement(Double(measurements.rightThighCircumference ?? 0))
        ]
    }
    
    private func formatMeasurement(_ value: Double?) -> String {
        guard let value = value else { return "N/A" }
        return String(format: "%.1f", value) // No conversion needed since measurements are already in inches
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
            
            let segmentedControl = UISegmentedControl(items: ["cm", "inch"])
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false

            // Set "inch" as the default selected segment
            segmentedControl.selectedSegmentIndex = 1 // 1 corresponds to the "inch" segment

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
        mapMeasurementsToValues()
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addButtonTapped() {
        // Handle adding new measurement
    }
}


