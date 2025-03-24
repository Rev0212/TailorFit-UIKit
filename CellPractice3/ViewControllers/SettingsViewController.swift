import UIKit

class SettingsViewController: UIViewController {

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
        return 2 // General Settings and About
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 // General Settings (Saved Measurements & Saved Try-On)
        case 1: return 2 // About Section (Help & About the App)
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = nil    // Reset text
        cell.imageView?.image = nil    // Reset image
        cell.textLabel?.textColor = .label

        switch indexPath.section {
        case 0: // General Settings
            if indexPath.row == 0 {
                cell.textLabel?.text = "Saved Measurements"
                cell.imageView?.image =
                    UIImage(systemName: "figure")?
                        .withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Saved Try-On"
                cell.imageView?.image =
                    UIImage(systemName: "tshirt.fill")?
                        .withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            }
        case 1: // About Section
            if indexPath.row == 0 {
                cell.textLabel?.text = "Help & Support"
                cell.imageView?.image =
                    UIImage(systemName: "questionmark.circle")?
                        .withRenderingMode(.alwaysOriginal)
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "About the App"
                cell.imageView?.image =
                    UIImage(systemName: "info.circle")?
                        .withRenderingMode(.alwaysOriginal)
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "General"
        case 1: return "About"
        default: return nil
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // General Settings
            if indexPath.row == 0 {
                let peopleVC = PeopleViewController()
                navigationController?.pushViewController(peopleVC, animated: true)
            } else if indexPath.row == 1 {
                let triedOnVc = SavedTryOnViewController()
                navigationController?.pushViewController(triedOnVc, animated: true)
            }
        case 1: // About Section
            if indexPath.row == 0 {
                let helpVC = HelpSupportViewController()
                navigationController?.pushViewController(helpVC, animated: true)
            } else if indexPath.row == 1 {
                let aboutVC = AboutTheAppViewController()
                navigationController?.pushViewController(aboutVC, animated: true)
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
