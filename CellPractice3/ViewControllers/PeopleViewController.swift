import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var peopleMeasurements: [UserMeasurements] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadJSONData()
        self.title = "Peoples"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loadJSONData() {
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "json") else {
            print("Error: JSON file not found")
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            peopleMeasurements = try decoder.decode([UserMeasurements].self, from: data)
            tableView.reloadData()
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleMeasurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userMeasurement = peopleMeasurements[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = userMeasurement.details.name
        cell.detailTextLabel?.text = "Age: \(userMeasurement.details.age)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Trigger segue
        performSegue(withIdentifier: "test", sender: peopleMeasurements[indexPath.row])
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test", let selectedUser = sender as? UserMeasurements {
            if let savedMeasurementsVC = segue.destination as? MeasurementSavedViewController {
                savedMeasurementsVC.detailsValues = [
                    "Name": selectedUser.details.name,
                    "Age": selectedUser.details.age,
                    "Info": selectedUser.details.info
                ]
                savedMeasurementsVC.sizeValues = [
                    "Shirt Size": selectedUser.size.shirt,
                    "Pant Size": selectedUser.size.pant
                ]
                
                // Accessing measurements directly as it's non-optional
                let measurements = selectedUser.measurements
                savedMeasurementsVC.measurementValues = [
                    "Shoulder Width": measurements.shoulderWidth?.description ?? "N/A",
                    "Chest Circumference": measurements.chestCircumference?.description ?? "N/A",
                    "Waist Circumference": measurements.waistCircumference?.description ?? "N/A",
                    "Hip Circumference": measurements.hipCircumference?.description ?? "N/A",
                    "Left Bicep Circumference": measurements.leftBicepCircumference?.description ?? "N/A",
                    "Right Bicep Circumference": measurements.rightBicepCircumference?.description ?? "N/A",
                    "Left Forearm Circumference": measurements.leftForearmCircumference?.description ?? "N/A",
                    "Right Forearm Circumference": measurements.rightForearmCircumference?.description ?? "N/A",
                    "Left Thigh Circumference": measurements.leftThighCircumference?.description ?? "N/A",
                    "Right Thigh Circumference": measurements.rightThighCircumference?.description ?? "N/A",
                    "Left Calf Circumference": measurements.leftCalfCircumference?.description ?? "N/A",
                    "Right Calf Circumference": measurements.rightCalfCircumference?.description ?? "N/A"
                ]
            }
        }
    }

}
