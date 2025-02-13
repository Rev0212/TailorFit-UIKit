//
//  MeasurementSaveViewController.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class MeasurementSaveViewController: UIViewController, SaveInputTableViewCellDelegate {
    func saveInputCellDidUpdateValue(_ cell: SaveInputTableViewCell, value: String) {
        guard let indexPath = tableView.indexPath(for: cell),
              let key = indexPath.section == 0 ? detailsOrder[indexPath.row] : nil else { return }
        detailsValues[key] = value
    }

    @IBOutlet private weak var tableView: UITableView!
    
    // Dictionaries to store values
    var detailsValues: [String: String] = ["Name": "", "Age": "", "Info": ""]
    var sizeValues = ["Shirt": "XL", "Pant": "L"]
    var measurementValues = ["Height": "183", "Chest": "57", "Waist": "63"]
    
    // Arrays to maintain order
    private let detailsOrder = ["Name", "Age", "Info"]
    private let sizeOrder = ["Shirt", "Pant"]
    private let measurementOrder = ["Height", "Chest", "Waist"]
    
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
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(SaveInputTableViewCell.self, forCellReuseIdentifier: "SaveInputCell")
        tableView.register(SaveDisplayTableViewCell.self, forCellReuseIdentifier: "SaveDisplayCell")
    }
    
    private func setupUI() {
        self.title = "Save Measurements"
        
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        detailsValues = originalDetailsValues
        sizeValues = originalSizeValues
        measurementValues = originalMeasurementValues
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        // Check if all required details are filled
        if !areAllDetailsFilled() {
            showWarningAlert(message: "Please fill in all the required details before saving.")
            return
        }
        
        // Proceed with saving data
        saveDataToFile()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // First, get the TabBarController
        if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController {
            
            // Set it as the root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
            
            // Optionally: Select the specific tab you want to show
            tabBarController.selectedIndex = 0 // Adjust this index based on your tab order
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleValueRestoration(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let value = userInfo["value"] as? String else {
            return
        }
        
        if detailsValues.keys.contains(title) {
            detailsValues[title] = value
        } else if sizeValues.keys.contains(title) {
            sizeValues[title] = value
        } else if measurementValues.keys.contains(title) {
            measurementValues[title] = value
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        tableView.contentInset.bottom = keyboardFrame.height
        tableView.scrollIndicatorInsets.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.bottom = 0
        tableView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc private func unitChanged(_ sender: UISegmentedControl) {
        currentUnit = sender.selectedSegmentIndex == 0 ? .cm : .inch
        convertMeasurements()
        tableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    // MARK: - Helper Methods
    
    private func convertMeasurements() {
        for (key, value) in measurementValues {
            if let numValue = Double(value) {
                if currentUnit == .inch {
                    let inchValue = numValue / 2.54
                    measurementValues[key] = String(format: "%.1f", inchValue)
                } else {
                    let cmValue = numValue * 2.54
                    measurementValues[key] = String(format: "%.1f", cmValue)
                }
            }
        }
    }
    
    private func areAllDetailsFilled() -> Bool {
        // Check if all required details are filled
        for key in detailsOrder {
            if detailsValues[key]?.isEmpty ?? true {
                return false
            }
        }
        return true
    }
    
    private func showWarningAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension MeasurementSaveViewController: UITableViewDelegate, UITableViewDataSource {
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveInputCell", for: indexPath) as! SaveInputTableViewCell
            let key = detailsOrder[indexPath.row]
            cell.configure(title: key, value: detailsValues[key] ?? "", delegate: self)
            cell.configureCellAppearance(isFirst: indexPath.row == 0,
                                       isLast: indexPath.row == detailsOrder.count - 1)
            return cell
            
        case 1, 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveDisplayCell", for: indexPath) as! SaveDisplayTableViewCell
            let key = indexPath.section == 1 ? sizeOrder[indexPath.row] : measurementOrder[indexPath.row]
            let value = indexPath.section == 1 ? sizeValues[key] : measurementValues[key]
            cell.configure(title: key, value: value ?? "")
            cell.configureCellAppearance(isFirst: indexPath.row == 0,
                                       isLast: indexPath.row == (indexPath.section == 1 ? sizeOrder.count : measurementOrder.count) - 1)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITextFieldDelegate

extension MeasurementSaveViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? SaveInputTableViewCell,
              let key = cell.titleLabel.text else { return }
        
        detailsValues[key] = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Data Persistence

extension MeasurementSaveViewController {
    private var dataFileName: String { "SavedData.json" }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getDataFileURL() -> URL {
        getDocumentsDirectory().appendingPathComponent(dataFileName)
    }
    
    private func saveDataToFile() {
        let dataToSave: [String: Any] = [
            "detailsValues": detailsValues,
            "sizeValues": sizeValues,
            "measurementValues": measurementValues
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dataToSave, options: [])
            try data.write(to: getDataFileURL())
            print("Data saved to file.")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    private func loadDataFromFile() {
        let fileURL = getDataFileURL()
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("No saved data file found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let loadedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                detailsValues = loadedData["detailsValues"] as? [String: String] ?? detailsValues
                sizeValues = loadedData["sizeValues"] as? [String: String] ?? sizeValues
                measurementValues = loadedData["measurementValues"] as? [String: String] ?? measurementValues
                print("Data loaded from file.")
            }
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }
}
