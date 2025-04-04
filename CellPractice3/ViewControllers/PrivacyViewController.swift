import UIKit

class PrivacyViewController: UIViewController {
    
    private let privacyTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .label
        textView.text = """
                PRIVACY POLICY
                
                Welcome to TryIt! Your privacy is important to us. 

                1. Information We Collect  
                - We collect images that you upload to the TryIt app.  
                - We do NOT share, sell, or use these images for any purpose other than app functionality.  
                
                2. How We Use Your Data  
                - Your images are used solely for processing within the app.  
                - All uploaded images are automatically deleted after 24 hours.  

                3. Data Security  
                - We take security seriously and use encryption to protect your data.  
                - No images are stored permanently on our servers.  

                4. Your Rights  
                - You can choose not to use the app if you disagree with these terms.  
                - By clicking “I Agree,” you confirm that you accept our policy.  

                If you have any concerns, contact support@tryitapp.com.  

                Thank you for using TryIt!
                """
                return textView
            }()
    // This text is a placeholder. Replace it with your actual privacy policy.
    private let agreeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        return toggle
    }()
    
    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "I agree to the Privacy Policy"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
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
    
    override func viewDidLoad() {
        title = "Privacy Policy"
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Enable Auto Layout
        privacyTextView.translatesAutoresizingMaskIntoConstraints = false
        agreeSwitch.translatesAutoresizingMaskIntoConstraints = false
        agreeLabel.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Subviews
        view.addSubview(privacyTextView)
        view.addSubview(agreeSwitch)
        view.addSubview(agreeLabel)
        view.addSubview(continueButton)
        
        // Set initial state
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        // Add Targets
        agreeSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        // Constraints
        NSLayoutConstraint.activate([
            privacyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            privacyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            privacyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            privacyTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            agreeSwitch.topAnchor.constraint(equalTo: privacyTextView.bottomAnchor, constant: 20),
            agreeSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            agreeLabel.centerYAnchor.constraint(equalTo: agreeSwitch.centerYAnchor),
            agreeLabel.leadingAnchor.constraint(equalTo: agreeSwitch.trailingAnchor, constant: 10),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
                continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // Adds padding
                continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Adds padding
                continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func switchToggled() {
        let isAgreed = agreeSwitch.isOn
        continueButton.isEnabled = isAgreed
        
        UIView.animate(withDuration: 0.3) {
            self.continueButton.alpha = isAgreed ? 1.0 : 0.5
        }
    }
    
    @objc private func continueTapped() {
        print("User agreed to the Privacy Policy")
        
        // Save agreement in UserDefaults
        UserDefaults.standard.set(true, forKey: "UserAgreedToPrivacy")
        
        // Navigate to Onboarding Screen
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            let onboardingVC = OnboardingViewController()
            window.rootViewController = onboardingVC
            window.makeKeyAndVisible()
        }
    }
}
