import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Tryit"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appTaglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Your personal fitting room"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1) // #1C1C1C
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        // Add slight shadow for depth
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFeaturesSection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateFeatures()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // Update UI elements for dark/light mode changes
            updateInterfaceForCurrentTraitCollection()
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Use system background color for automatic dark/light mode support
        view.backgroundColor = .systemBackground
        
        // Add scrollView and contentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add elements to contentView
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appTaglineLabel)
        
        // Add buttons at the view level (not in scrollView)
        view.addSubview(continueButton)
        
        // ScrollView and ContentView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // Height will be determined by content
        ])
        
        // Header Constraints
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            appNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            appNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            appTaglineLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8),
            appTaglineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            appTaglineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
        // Button Constraints
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        // Button Actions
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Features Section
    private func setupFeaturesSection() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // Feature 1: Virtual Try-On
        let feature1 = createFeatureView(
            iconName: "tshirt.fill",
            iconColor: .systemBlue,
            title: "Virtual Try-On",
            description: "Try on clothes from any shopping screenshot with on-device AI."
        )
        
        // Feature 2: Measure
        let feature2 = createFeatureView(
            iconName: "figure",
            iconColor: .systemGreen,
            title: "Get Your Perfect Fit",
            description: "Get your size and measurements with just a single photo."
        )
        
        // Feature 3: Added a third feature for better onboarding
        let feature3 = createFeatureView(
            iconName: "tag.fill",
            iconColor: .systemOrange,
            title: "Save & Compare",
            description: "Save your favorite looks and compare different outfits side by side."
        )
        
        stackView.addArrangedSubview(feature1)
        stackView.addArrangedSubview(feature2)
        stackView.addArrangedSubview(feature3)
        
        // Add stackView to the contentView
        contentView.addSubview(stackView)
        
        // Set tag for animation
        feature1.tag = 100
        feature2.tag = 101
        feature3.tag = 102
        
        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: appTaglineLabel.bottomAnchor, constant: 48),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Create Feature View
    private func createFeatureView(iconName: String, iconColor: UIColor, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // Initial state for animation
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(translationX: 50, y: 0)
        
        // Create icon container with circular background
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = iconColor.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = 26
        
        // Icon ImageView
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = iconColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Text Stack (Title and Description)
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        
        // Add icon to container
        iconContainer.addSubview(iconImageView)
        
        // Add Subviews
        containerView.addSubview(iconContainer)
        containerView.addSubview(textStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 52),
            iconContainer.heightAnchor.constraint(equalToConstant: 52),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            textStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    // MARK: - Animations
    private func animateFeatures() {
        // Animate each feature in sequence with a slight delay
        let featureViews = [
            contentView.viewWithTag(100),
            contentView.viewWithTag(101),
            contentView.viewWithTag(102)
        ].compactMap { $0 }
        
        for (index, view) in featureViews.enumerated() {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.2 * Double(index),
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: []
            ) {
                view.alpha = 1
                view.transform = .identity
            }
        }
    }
    
    // MARK: - Interface Updates
    private func updateInterfaceForCurrentTraitCollection() {
        // Update UI elements for dark/light mode if needed
        // This method is kept for potential future customization
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        print("Continue button tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? UITabBarController {
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true, completion: nil)
        } else {
            print("Failed to instantiate MainViewController as UITabBarController")
        }
    }
}
