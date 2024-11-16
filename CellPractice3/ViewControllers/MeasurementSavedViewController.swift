//
//  MeasurementSavedViewController.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class MeasurementSavedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
        
        @IBOutlet var savedTable: UITableView!
        
        // Dictionaries to store values
        var detailsValues: [String: String] = [:]
        var sizeValues: [String: String] = [:]
        var measurementValues: [String: String] = [:]
        
        // Arrays to maintain order of keys
        private let detailsOrder = ["Name", "Age", "Info"]
        private let sizeOrder = ["shirt", "pant"]
        private let measurementOrder = ["Chest", "Waist", "Hip", "Inseam", "Shoulder"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
        private func setupUI() {
            title = "Saved Measurements"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Cancel",
                style: .plain,
                target: self,
                action: #selector(cancelAction)
            )
            
            // Register the custom cell with the xib file
            let nib = UINib(nibName: "SavedDisplayCell", bundle: nil)
            savedTable.register(nib, forCellReuseIdentifier: "SavedDisplayCell")
            savedTable.delegate = self
            savedTable.dataSource = self
            savedTable.separatorStyle = .none
            savedTable.backgroundColor = .systemGroupedBackground
        }
        
        @objc private func cancelAction() {
            navigationController?.popViewController(animated: true)
        }
        
        // MARK: - TableView DataSource & Delegate
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0: return detailsOrder.count
            case 1: return sizeOrder.count
            case 2: return measurementOrder.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedDisplayCell", for: indexPath) as? SavedDisplayCellTableViewCell else {
                return UITableViewCell()
            }
            
            let title: String
            let value: String
            
            switch indexPath.section {
            case 0:
                title = detailsOrder[indexPath.row]
                value = detailsValues[title] ?? "N/A"
            case 1:
                title = sizeOrder[indexPath.row]
                value = sizeValues[title] ?? "N/A"
            case 2:
                title = measurementOrder[indexPath.row]
                value = measurementValues[title] ?? "N/A"
            default:
                return UITableViewCell()
            }
            
            cell.configure(title: title, value: value)
            return cell
        }
        
        // MARK: - Update TableView
        func updateTableViewData(details: [String: String], sizes: [String: String], measurements: [String: String]) {
            detailsValues = details
            sizeValues = sizes
            measurementValues = measurements
            savedTable.reloadData()
        }
}
    
