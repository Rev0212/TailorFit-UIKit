import UIKit

class RegisterScreen: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start your virtual fitting journey"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "First name"
        textField.autocapitalizationType = .words
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lastNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Last name"
        textField.autocapitalizationType = .words
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Confirm password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordRequirementsLabel: UILabel = {
        let label = UILabel()
        label.text = "Password must be at least 8 characters"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have an account? Login here", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDelegates()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [titleLabel, subtitleLabel, firstNameTextField, lastNameTextField,
         emailTextField, passwordTextField, confirmPasswordTextField,
         passwordRequirementsLabel, createAccountButton, loginButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            firstNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.topAnchor),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            passwordRequirementsLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 8),
            passwordRequirementsLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordRequirementsLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            createAccountButton.topAnchor.constraint(equalTo: passwordRequirementsLabel.bottomAnchor, constant: 24),
            createAccountButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            createAccountButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        [firstNameTextField, lastNameTextField, emailTextField,
         passwordTextField, confirmPasswordTextField].forEach {
            $0.delegate = self
        }
    }
    
    @objc private func createAccountTapped() {
        // Validate all fields are filled
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            // Show error alert for empty fields
            let alert = UIAlertController(title: "Error",
                                           message: "All fields must be filled",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            let alert = UIAlertController(title: "Error",
                                           message: "Invalid email format",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Validate password strength
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        guard passwordPredicate.evaluate(with: password) else {
            let alert = UIAlertController(title: "Error",
                                           message: "Password must be at least 8 characters long, with uppercase, lowercase, number, and special character",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Validate passwords match
        guard password == confirmPassword else {
            let alert = UIAlertController(title: "Error",
                                           message: "Passwords do not match",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Print entered details
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        print("Email: \(email)")
        print("Password: \(password)")
        
        // Proceed with account creation logic
        let alert = UIAlertController(title: "Success",
                                       message: "Account created successfully",
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    @objc private func loginTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
