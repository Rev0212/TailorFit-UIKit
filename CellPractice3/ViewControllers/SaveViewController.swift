//
//  ViewController.swift
//  CellPractice3
//
//  Created by admin29 on 01/11/24.
//

import UIKit

class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    // Current values for the input fields
    var detailsValues = ["Name": "Hariharan", "Age": "19", "Info": "Cool guy"]
    var sizeValues = ["Shirt": "XL", "Pant": "L"]
    var measurementValues = ["Height": "183", "Chest": "57", "Waist": "63"]
    
    // Original values storage
    private var originalDetailsValues: [String: String]!
    private var originalSizeValues: [String: String]!
    private var originalMeasurementValues: [String: String]!
    
    var currentUnit: MeasurementUnit = .cm
    
    enum MeasurementUnit {
        case cm
        case inch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        storeOriginalValues()
        setupNotificationObserver()
    }
    
    private func setupUI() {
        self.title = "Measurements"
        
        // Navigation bar appearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        // TableView setup
        tableView.register(DemoTableViewCell.nib(), forCellReuseIdentifier: DemoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func storeOriginalValues() {
        originalDetailsValues = detailsValues
        originalSizeValues = sizeValues
        originalMeasurementValues = measurementValues
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleValueRestoration(_:)),
            name: NSNotification.Name("ValueRestoredNotification"),
            object: nil
        )
    }
    
    @objc private func handleValueRestoration(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let value = userInfo["value"] as? String else {
            return
        }
        
        // Update the appropriate dictionary based on the title
        if detailsValues.keys.contains(title) {
            detailsValues[title] = value
        } else if sizeValues.keys.contains(title) {
            sizeValues[title] = value
        } else if measurementValues.keys.contains(title) {
            measurementValues[title] = value
        }
    }
    
    @objc private func cancelButtonTapped() {
        // Restore all original values
        detailsValues = originalDetailsValues
        sizeValues = originalSizeValues
        measurementValues = originalMeasurementValues
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        // Handle save action
        print("Save button tapped")
        print("Details: \(detailsValues)")
        print("Size: \(sizeValues)")
        print("Measurements: \(measurementValues)")
        // Add your save logic here
    }
    
    // MARK: - TableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return detailsValues.count
        case 1: return sizeValues.count
        case 2: return measurementValues.count
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
            titleLabel.text = "Details"
        case 1:
            titleLabel.text = "Size"
        case 2:
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
            let key = Array(detailsValues.keys)[indexPath.row]
            cell.configure(title: key, value: detailsValues[key] ?? "", style: .detail)
        case 1:
            let key = Array(sizeValues.keys)[indexPath.row]
            cell.configure(title: key, value: sizeValues[key] ?? "", style: .size)
        case 2:
            let key = Array(measurementValues.keys)[indexPath.row]
            cell.configure(title: key, value: measurementValues[key] ?? "", style: .measurement)
        default:
            break
        }
        
        // Apply rounded corners for first and last cells in each section
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.configureCellAppearance(isFirst: isFirstCell, isLast: isLastCell)
        
        return cell
    }
    
    @objc private func unitChanged(_ sender: UISegmentedControl) {
        currentUnit = sender.selectedSegmentIndex == 0 ? .cm : .inch
        convertMeasurements()
        tableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    private func convertMeasurements() {
        for (key, value) in measurementValues {
            if let numValue = Double(value) {
                if currentUnit == .inch {
                    // Convert cm to inches
                    let inchValue = numValue / 2.54
                    measurementValues[key] = String(format: "%.1f", inchValue)
                } else {
                    // Convert inches to cm
                    let cmValue = numValue * 2.54
                    measurementValues[key] = String(format: "%.1f", cmValue)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

