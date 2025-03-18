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
    
    private let mobileNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Mobile Number"
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendOtpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send OTP", for: .normal)
        button.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let otpTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter OTP"
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true // Initially hidden
        return textField
    }()
    
    private let verifyOtpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify OTP", for: .normal)
        button.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
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
         emailTextField, mobileNumberTextField, sendOtpButton, otpTextField,
         verifyOtpButton, createAccountButton, loginButton].forEach {
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
            
            mobileNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            mobileNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mobileNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            sendOtpButton.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 16),
            sendOtpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            sendOtpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sendOtpButton.heightAnchor.constraint(equalToConstant: 50),
            
            otpTextField.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 16),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            verifyOtpButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 16),
            verifyOtpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            verifyOtpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            verifyOtpButton.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.topAnchor.constraint(equalTo: verifyOtpButton.bottomAnchor, constant: 16),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        sendOtpButton.addTarget(self, action: #selector(sendOtpTapped), for: .touchUpInside)
        verifyOtpButton.addTarget(self, action: #selector(verifyOtpTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        [firstNameTextField, lastNameTextField, emailTextField, mobileNumberTextField, otpTextField].forEach {
            $0.delegate = self
        }
    }
    
    @objc private func sendOtpTapped() {
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            AuthUtility.shared.showAlert(on: self, message: "Please enter your mobile number.")
            return
        }
        
        if mobileNumber.count < 10 {
            AuthUtility.shared.showAlert(on: self, message: "Please enter a valid 10-digit mobile number.")
            return
        }
        
        AuthUtility.shared.sendOtp(to: mobileNumber) { success, error in
            if success {
                self.sendOtpButton.isHidden = true
                self.otpTextField.isHidden = false
                self.verifyOtpButton.isHidden = false
                self.otpTextField.becomeFirstResponder()
                
                AuthUtility.shared.showAlert(on: self, message: "OTP sent successfully!", title: "Success")
            } else {
                AuthUtility.shared.showAlert(on: self, message: error ?? "Failed to send OTP.")
            }
        }
    }
    
    @objc private func verifyOtpTapped() {
        guard let otp = otpTextField.text, !otp.isEmpty else {
            AuthUtility.shared.showAlert(on: self, message: "Please enter the OTP.")
            return
        }
        
        AuthUtility.shared.verifyOtp(mobileNumber: mobileNumberTextField.text ?? "", otp: otp) { success, error in
            if success {
                self.verifyOtpButton.isHidden = true
                self.createAccountButton.isHidden = false
                self.otpTextField.isHidden = true
                AuthUtility.shared.showAlert(on: self, message: "OTP verified successfully!", title: "Success")
            } else {
                AuthUtility.shared.showAlert(on: self, message: error ?? "Invalid OTP.")
            }
        }
    }
    
    @objc private func createAccountTapped() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            AuthUtility.shared.showAlert(on: self, message: "All fields must be filled.")
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            AuthUtility.shared.showAlert(on: self, message: "Invalid email format.")
            return
        }
        
        APIService.shared.signup(firstName: firstName, lastName: lastName, email: email, mobile: mobileNumber) { result in
            switch result {
            case .success(let response):
                if response.success {
                    let alert = UIAlertController(title: "Success",
                                                message: response.message,
                                                preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                } else {
                    AuthUtility.shared.showAlert(on: self, message: response.message)
                }
            case .failure(let error):
                AuthUtility.shared.showAlert(on: self, message: error.localizedDescription)
            }
        }
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
            mobileNumberTextField.becomeFirstResponder()
        case mobileNumberTextField:
            mobileNumberTextField.resignFirstResponder()
        case otpTextField:
            otpTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
