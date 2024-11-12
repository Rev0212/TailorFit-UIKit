//
//  ViewController.swift
//  CellPractice3
//
//  Created by admin29 on 01/11/24.
//

import UIKit

class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    
       var detailsValues: [String: String] = ["Name": "", "Age": "","Info": ""]
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
    
    enum CellStyle {
           case input    // For user input cells (details)
           case display  // For display-only cells (measurements and sizes)
       }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            storeOriginalValues()
            setupNotificationObserver()
            
            // Register for keyboard notifications
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    private func setupUI() {
           self.title = "Save Measurements"
           
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
           tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "InputCell")
           tableView.register(DisplayTableViewCell.self, forCellReuseIdentifier: "DisplayCell")
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorStyle = .none
           tableView.backgroundColor = .systemGroupedBackground
           
           // Add tap gesture to dismiss keyboard
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
       }
       
       // MARK: - Keyboard Handling
       
       @objc private func keyboardWillShow(notification: NSNotification) {
           guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
           tableView.contentInset.bottom = keyboardFrame.height
           tableView.scrollIndicatorInsets.bottom = keyboardFrame.height
       }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           tableView.contentInset.bottom = 0
           tableView.scrollIndicatorInsets.bottom = 0
       }
       
       @objc private func dismissKeyboard() {
           view.endEditing(true)
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
        performSegue(withIdentifier: "navigateToSavedMeasurements", sender: "rightBarButtonItem")
        saveDataToFile() // Save data to file
            print("Data saved.")
    }
    
//MARK: - Data Saving
    
    private let dataFileName = "SavedData.json"

    // Get the URL for the app's Documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Get the file URL for storing the data
    private func getDataFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(dataFileName)
    }

    // Save data to file
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

    // Load data from file
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
    
    // MARK: - TableView DataSource & Delegate
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          switch indexPath.section {
          case 0: // Details section with input
              let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
              let key = Array(detailsValues.keys)[indexPath.row]
              cell.configure(title: key, value: detailsValues[key] ?? "", delegate: self)
              cell.configureCellAppearance(isFirst: indexPath.row == 0,
                                         isLast: indexPath.row == detailsValues.count - 1)
              return cell
              
          case 1: // Size section (display only)
              let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath) as! DisplayTableViewCell
              let key = Array(sizeValues.keys)[indexPath.row]
              cell.configure(title: key, value: sizeValues[key] ?? "")
              cell.configureCellAppearance(isFirst: indexPath.row == 0,
                                         isLast: indexPath.row == sizeValues.count - 1)
              return cell
              
          case 2: // Measurements section (display only)
              let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath) as! DisplayTableViewCell
              let key = Array(measurementValues.keys)[indexPath.row]
              cell.configure(title: key, value: measurementValues[key] ?? "")
              cell.configureCellAppearance(isFirst: indexPath.row == 0,
                                         isLast: indexPath.row == measurementValues.count - 1)
              return cell
              
          default:
              return UITableViewCell()
          }
      }
    
    // MARK: - UITextFieldDelegate
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? InputTableViewCell,
              let key = cell.key else { return } // Retrieve the key from the cell

        detailsValues[key] = textField.text // Update the dictionary with the new value
    }
 
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
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
                    measurementValues[key] = String(format: "%f", inchValue)
                } else {
                    // Convert inches to cm
                    let cmValue = numValue * 2.54
                    measurementValues[key] = String(format: "%f", cmValue)
                }
            }
        }
    }
    // MARK: - Custom Cells

    class InputTableViewCell: UITableViewCell {
        private let titleLabel = UILabel()
        private let inputField = UITextField()
        var key: String? // Add this property
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               super.init(style: style, reuseIdentifier: reuseIdentifier)
               setupUI()
           }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
        
        private func setupUI() {
            contentView.backgroundColor = .systemBackground
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            inputField.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(inputField)
            
            inputField.borderStyle = .none
            inputField.textAlignment = .right
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                inputField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                inputField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                inputField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
                
                contentView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        func configure(title: String, value: String, delegate: UITextFieldDelegate) {
               titleLabel.text = title
               inputField.text = value
               inputField.delegate = delegate
               inputField.placeholder = "Enter \(title.lowercased())"
               key = title // Set the key property
           }
        
        func configureCellAppearance(isFirst: Bool, isLast: Bool) {
            // Add rounded corners for first/last cells
            layer.cornerRadius = isFirst || isLast ? 10 : 0
            layer.maskedCorners = isFirst ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
                                 isLast ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
            clipsToBounds = true
        }
    }

    class DisplayTableViewCell: UITableViewCell {
        private let titleLabel = UILabel()
        private let valueLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            contentView.backgroundColor = .systemBackground
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(valueLabel)
            
            valueLabel.textAlignment = .right
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
                
                contentView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        func configure(title: String, value: String) {
            titleLabel.text = title
            valueLabel.text = value
        }
        
        func configureCellAppearance(isFirst: Bool, isLast: Bool) {
            layer.cornerRadius = isFirst || isLast ? 10 : 0
            layer.maskedCorners = isFirst ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
                                 isLast ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
            clipsToBounds = true
        }
    }
}

