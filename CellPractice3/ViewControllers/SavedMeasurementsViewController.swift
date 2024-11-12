//
//  SavedMeasurementsViewController.swift
//  CellPractice3
//
//  Created by admin29 on 08/11/24.
//

import UIKit

class SavedMeasurementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var savedTable: UITableView!
    
    private var detailsValues: [String: String] = [:]
    private var sizeValues: [String: String] = [:]
    private var measurementValues: [String: String] = [:]
    private let dataFileName = "SavedData.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDataFromFile()
    }
 
    private func setupUI() {
        self.title = "Measurements"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: nil        )
        
        // TableView setup
        savedTable.register(DisplayTableViewCell.self, forCellReuseIdentifier: "DisplayCell")
        savedTable.delegate = self
        savedTable.dataSource = self
        savedTable.separatorStyle = .none
        savedTable.backgroundColor = .systemGroupedBackground
    }
    
 
    //MARK: - Data Loading
 
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func getDataFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(dataFileName)
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
                detailsValues = loadedData["detailsValues"] as? [String: String] ?? [:]
                sizeValues = loadedData["sizeValues"] as? [String: String] ?? [:]
                measurementValues = loadedData["measurementValues"] as? [String: String] ?? [:]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath) as! DisplayTableViewCell
        
        switch indexPath.section {
        case 0:
            let key = Array(detailsValues.keys)[indexPath.row]
            cell.configure(title: key, value: detailsValues[key] ?? "")
            
        case 1:
            let key = Array(sizeValues.keys)[indexPath.row]
            cell.configure(title: key, value: sizeValues[key] ?? "")
            
        case 2:
            let key = Array(measurementValues.keys)[indexPath.row]
            cell.configure(title: key, value: measurementValues[key] ?? "")
            
        default:
            break
        }
        
        return cell
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
}

