import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - UI Elements
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Tryit"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1) // #1C1C1C
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFeaturesSection()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(appNameLabel)
        view.addSubview(continueButton)

        // Constraints
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Continue Button Action
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    // MARK: - Setup Features Section
    private func setupFeaturesSection() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center

        // Feature 1: Virtual Try-On
        let feature1 = createFeatureView(
            iconName: "tshirt.fill",
            iconColor: .red,
            title: "Virtual Try-On",
            description: "Try on clothes from any shopping screenshot with on-device AI."
        )
        stackView.addArrangedSubview(feature1)

        // Feature 2: Measure
        let feature2 = createFeatureView(
            iconName: "figure",
            iconColor: .green,
            title: "Measure",
            description: "Get your size and measurements with just a single photo."
        )
        stackView.addArrangedSubview(feature2)

        // Add stackView to the view
        view.addSubview(stackView)

        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 80),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -20)
        ])
    }

    // MARK: - Create Feature View
    private func createFeatureView(iconName: String, iconColor: UIColor, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Icon ImageView
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = iconColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Text Stack (Title and Description)
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)

        // Add Subviews
        containerView.addSubview(iconImageView)
        containerView.addSubview(textStack)

        // Constraints
        NSLayoutConstraint.activate([
            // Icon Constraints
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            // Text Stack Constraints
            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])

        return containerView
    }

    // MARK: - Actions
    @objc private func continueButtonTapped() {
        performSegue(withIdentifier: "taketomain", sender: self)
    }
}
