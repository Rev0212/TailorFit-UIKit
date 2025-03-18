import UIKit

class MeasurementSaveViewController: UIViewController, SaveInputTableViewCellDelegate, SaveInputTableViewCell.SaveInputTableViewCellDelegate {
    
    var fetchedMeasurements: BodyMeasurement?

    // MARK: - Properties
    private let tableView = UITableView()
    
    // Dictionaries to store values
    var detailsValues: [String: String] = ["Name": "", "Age": ""]
    var sizeValues = ["Shirt": "XL", "Pant": "L"]
    var measurementValues = ["Height": "183", "Chest": "57", "Waist": "63"]
    
    // Arrays to maintain order
    private let detailsOrder = ["Name", "Age"]
    private let sizeOrder = ["Shirt", "Pant"]
    private let measurementOrder = ["Height", "Chest", "Waist"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Register cells
        tableView.register(SaveInputTableViewCell.self, forCellReuseIdentifier: SaveInputTableViewCell.reuseIdentifier)
        tableView.register(SaveDisplayTableViewCell.self, forCellReuseIdentifier: SaveDisplayTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - SaveInputTableViewCellDelegate
    func saveInputCellDidUpdateValue(_ cell: SaveInputTableViewCell, value: String) {
        guard let indexPath = tableView.indexPath(for: cell),
              indexPath.section == 0 else { return }
        
        let key = detailsOrder[indexPath.row]
        detailsValues[key] = value
    }
}

// MARK: - UITableViewDataSource & Delegate
extension MeasurementSaveViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SaveInputTableViewCell.reuseIdentifier, for: indexPath) as! SaveInputTableViewCell
            let key = detailsOrder[indexPath.row]
            cell.configure(title: key, value: detailsValues[key] ?? "", delegate: self)
            return cell
            
        case 1, 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SaveDisplayTableViewCell.reuseIdentifier, for: indexPath) as! SaveDisplayTableViewCell
            let key = indexPath.section == 1 ? sizeOrder[indexPath.row] : measurementOrder[indexPath.row]
            let value = indexPath.section == 1 ? sizeValues[key] : measurementValues[key]
            cell.configure(title: key, value: value ?? "")
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
