import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    private var tableView: UITableView!
    private var savedDataArray: [SavedData] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.title = "Saved Measurements"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedData() // Reload data every time view appears
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Configure the table view
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Add constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Data Loading
    private func loadSavedData() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("SavedData.json")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("No saved data file found")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            if let loadedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let savedData = SavedData(
                    detailsValues: loadedData["detailsValues"] as? [String: String] ?? [:],
                    sizeValues: loadedData["sizeValues"] as? [String: String] ?? [:],
                    measurementValues: loadedData["measurementValues"] as? [String: String] ?? [:]
                )
                savedDataArray = [savedData] // For now, storing as single entry
                tableView.reloadData()
            }
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let savedData = savedDataArray[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = savedData.detailsValues["Name"] ?? "Unknown"
        if let age = savedData.detailsValues["Age"] {
            cell.detailTextLabel?.text = "Age: \(age)"
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let savedData = savedDataArray[indexPath.row]
        navigateToMeasurementSavedViewController(with: savedData)
    }

    // MARK: - Navigation
    private func navigateToMeasurementSavedViewController(with savedData: SavedData) {
        let savedMeasurementsVC = MeasurementSavedViewController()
        savedMeasurementsVC.detailsValues = savedData.detailsValues
        savedMeasurementsVC.sizeValues = savedData.sizeValues
        savedMeasurementsVC.measurementValues = savedData.measurementValues
        navigationController?.pushViewController(savedMeasurementsVC, animated: true)
    }
}
