import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    private let sectionHeadings = ["BEFORE YOU START", "DURING MEASUREMENT"]
    private let instructionItems = [
        ["Wear Fitting Clothes", "Good Lighting", "Distance", "Clear Space"],
        ["Stand Straight", "Stay Still"]
    ]
    private let descriptionItems = [
       ["Wear close-fitting clothes for accurate measurements", "Ensure you're in a well-lit area", "Stand 2-3 meters away from the camera", "Make sure no other people are in the frame"],
       ["Keep your arms slightly away from your body", "Remain still until the scan is complete"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Instructions"
        tableView.dataSource = self
        tableView.delegate = self
        // Register the custom cell class
        tableView.register(InstructionTableViewCell.self, forCellReuseIdentifier: "instructionCell")
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeadings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as? InstructionTableViewCell else {
            return UITableViewCell()
        }

        let instruction = instructionItems[indexPath.section][indexPath.row]
        cell.titleLabel.text = instruction
        cell.descriptionLabel.text = descriptionItems[indexPath.section][indexPath.row]

        // Set the icon image based on the instruction
        switch instruction {
        case "Wear Fitting Clothes":
            cell.iconImageView.image = UIImage(systemName: "person.fill")
        case "Good Lighting":
            cell.iconImageView.image = UIImage(systemName: "lightbulb")
        case "Distance":
            cell.iconImageView.image = UIImage(systemName: "ruler")
        case "Clear Space":
            cell.iconImageView.image = UIImage(systemName: "clear")
        case "Stand Straight":
            cell.iconImageView.image = UIImage(systemName: "figure.stand")
        case "Stay Still":
            cell.iconImageView.image = UIImage(systemName: "pause.circle")
        default:
            cell.iconImageView.image = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeadings[section]
    }

    // MARK: - Custom UITableViewCell Class

    class InstructionTableViewCell: UITableViewCell {
        
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let iconImageView = UIImageView()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            // Configure iconImageView
            iconImageView.contentMode = .scaleAspectFit
            contentView.addSubview(iconImageView)

            // Configure titleLabel
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            contentView.addSubview(titleLabel)

            // Configure descriptionLabel
            descriptionLabel.font = UIFont.systemFont(ofSize: 12)
            descriptionLabel.textColor = .gray
            contentView.addSubview(descriptionLabel)

            // Set up layout constraints
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 30),
                iconImageView.heightAnchor.constraint(equalToConstant: 30),

                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                
                descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


