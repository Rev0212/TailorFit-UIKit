import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    var profileName: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.profileName.rawValue) ?? "User"
    }

    var profileImage: UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: UserDefaultsKeys.profileImage.rawValue) {
            return UIImage(data: imageData)
        }
        return UIImage(systemName: "person.circle.fill") // Default profile image
    }

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData() // Ensures UI updates correctly
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Setup TableView
    private func setupTableView() {
        tableView.backgroundColor = .white
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
        case 0: return 1 // Profile Section (Login or Profile)
        case 1: return 2 // General Settings (Saved Measurements & Saved Try-On)
        case 2: return 2 // About Section (Help & About the App)
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = nil // Reset text
        cell.imageView?.image = nil // Reset image
        cell.textLabel?.textColor = .label // Reset text color

        switch indexPath.section {
        case 0: // Profile Section
            if isLoggedIn {
                cell.textLabel?.text = profileName
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                
                let profileImageSize = CGSize(width: 40, height: 40)
                if let profileImage = profileImage {
                    let resizedImage = profileImage.resized(to: profileImageSize)
                    cell.imageView?.image = resizedImage
                }
                
                cell.imageView?.layer.cornerRadius = profileImageSize.width / 2
                cell.imageView?.clipsToBounds = true
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "Login or Register"
                cell.textLabel?.textColor = .systemBlue
                cell.imageView?.image = UIImage(systemName: "person.crop.circle.fill")
            }
        case 1: // General Settings
            if indexPath.row == 0 {
                cell.textLabel?.text = "Saved Measurements"
                cell.imageView?.image = UIImage(systemName: "figure")?.withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "Saved Try-On"
                cell.imageView?.image = UIImage(systemName: "tshirt.fill")?.withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            }
        case 2: // About Section
            if indexPath.row == 0 {
                cell.textLabel?.text = "Help & Support"
                cell.imageView?.image = UIImage(systemName: "questionmark.circle")?.withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "About the App"
                cell.imageView?.image = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysOriginal)
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Profile"
        case 1: return "General"
        case 2: return "About"
        default: return nil
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // Profile Section
            if isLoggedIn {
                let profileVC = ProfileViewController()
                navigationController?.pushViewController(profileVC, animated: true)
            } else {
                let loginVC = LoginScreen()
//                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            }
        case 1: // General Settings
            if indexPath.row == 0 {
                let peopleVC = PeopleViewController()
                navigationController?.pushViewController(peopleVC, animated: true)
            } else if indexPath.row == 1 {
                let triedOnVc = SavedTryOnViewController()
                navigationController?.pushViewController(triedOnVc, animated: true)
            }
        case 2: // About Section
            if indexPath.row == 0 {
                print("Navigate to Help & Support")
            } else if indexPath.row == 1 {
                print("Navigate to About the App")
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 60
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
