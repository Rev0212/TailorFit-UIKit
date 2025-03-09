import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    var isLoggedIn: Bool = true // Change this based on login status
    var profileImage: UIImage? = UIImage(systemName: "person.circle.fill") // Default profile image
    var profileName: String? = "Hariharan" // Default profile name

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.separatorStyle = .singleLine
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Add tableView to the view
        view.addSubview(tableView)

        // Set the background color of the tableView
        tableView.backgroundColor = .systemBackground

        // Constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Setup TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Profile, General Settings, and About
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Profile Section
            return isLoggedIn ? 1 : 1 // Login/Register or Profile
        case 1: // General Settings Section
            return 2 // Check Measurements and Virtual Try-On
        case 2: // About Section
            return 2 // Help & Support and About the App
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero // Remove default left padding
        cell.selectionStyle = .none

        switch indexPath.section {
        case 0: // Profile Section
            if isLoggedIn {
                // Profile Cell
                cell.textLabel?.text = profileName
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium) // Optional: Increase font size
                
                // Resize the profile image
                let profileImageSize = CGSize(width: 40, height: 40) // Set your desired size
                if let profileImage = profileImage {
                    let resizedImage = profileImage.resized(to: profileImageSize)
                    cell.imageView?.image = resizedImage
                }
                
                cell.imageView?.tintColor = .systemGray
                cell.imageView?.layer.cornerRadius = profileImageSize.width / 2 // Make it circular
                cell.imageView?.clipsToBounds = true
                cell.accessoryType = .disclosureIndicator
            } else {
                // Login/Register Cell
                cell.textLabel?.text = "Login or Register"
                cell.textLabel?.textColor = .systemBlue
                cell.imageView?.image = UIImage(systemName: "person.crop.circle.fill")
                cell.imageView?.tintColor = .systemGray
            }
        case 1: // General Settings Section
            if indexPath.row == 0 {
                // Check Measurements
                cell.textLabel?.text = "Saved Measurements"
                cell.imageView?.image = UIImage(systemName: "figure")
            } else if indexPath.row == 1 {
                // Virtual Try-On
                cell.textLabel?.text = "Saved Try-On"
                cell.imageView?.image = UIImage(systemName: "tshirt.fill")
            }
        case 2: // About Section
            if indexPath.row == 0 {
                // Help & Support
                cell.textLabel?.text = "Help & Support"
                cell.imageView?.image = UIImage(systemName: "questionmark.circle")
            } else if indexPath.row == 1 {
                // About the App
                cell.textLabel?.text = "About the App"
                cell.imageView?.image = UIImage(systemName: "info.circle")
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        case 1:
            return "General"
        case 2:
            return "About"
        default:
            return nil
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // Profile Section
            if isLoggedIn {
                // Navigate to Profile
                let profileVC = ProfileViewController()
                navigationController?.pushViewController(profileVC, animated: true)
            } else {
                // Navigate to Login/Register
                print("Navigate to Login/Register")
            }
        case 1: // General Settings Section
            if indexPath.row == 0 {
                // Navigate to Check Measurements
                print("Navigate to Check Measurements")
                let peopleVC = PeopleViewController()
                navigationController?.pushViewController(peopleVC, animated: true)
            } else if indexPath.row == 1 {
                // Navigate to Virtual Try-On
                print("Navigate to Virtual Try-On")
            }
        case 2: // About Section
            if indexPath.row == 0 {
                // Navigate to Help & Support
                print("Navigate to Help & Support")
            } else if indexPath.row == 1 {
                // Navigate to About the App
                print("Navigate to About the App")
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80 // Increase row height for the profile section
        }
        return 60 // Default row height for other sections
    }
}

// MARK: - UIImage Extension for Resizing
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
