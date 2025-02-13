import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var savedDataArray: [SavedData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "People"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedData() // Reload data every time view appears
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
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
        performSegue(withIdentifier: "test", sender: savedDataArray[indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test",
           let savedData = sender as? SavedData,
           let savedMeasurementsVC = segue.destination as? MeasurementSavedViewController {
            
            savedMeasurementsVC.detailsValues = savedData.detailsValues
            savedMeasurementsVC.sizeValues = savedData.sizeValues
            savedMeasurementsVC.measurementValues = savedData.measurementValues
        }
    }
}
