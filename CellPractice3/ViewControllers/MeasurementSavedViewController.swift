import UIKit

class MeasurementSavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Programmatically create the UITableView
    private var savedTable: UITableView!
    
    // Dictionaries to store values
    var detailsValues: [String: String] = [:]
    var sizeValues: [String: String] = [:]
    var measurementValues: [String: String] = [:]
    
    // Arrays to maintain order of keys
    private let detailsOrder = ["Name"]
    private let sizeOrder = ["Shirt", "Pant"]
    private let measurementOrder = ["Chest", "Waist", "Hip"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Saved Measurements"
        
        // Set up the navigation bar back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )


        
        // Initialize and configure the UITableView
        savedTable = UITableView(frame: view.bounds, style: .grouped)
        savedTable.register(SavedDisplayCell.self, forCellReuseIdentifier: "SavedDisplayCell")
        savedTable.delegate = self
        savedTable.dataSource = self
        savedTable.separatorStyle = .singleLine
        savedTable.separatorColor = .lightGray
        savedTable.backgroundColor = .white
        savedTable.tableFooterView = UIView() // Remove extra separators
        
        // Add the table view to the view hierarchy
        view.addSubview(savedTable)
    }
    
    @objc private func backAction() {
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
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .darkGray
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedDisplayCell", for: indexPath) as? SavedDisplayCell else {
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
        cell.backgroundColor = .white
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
