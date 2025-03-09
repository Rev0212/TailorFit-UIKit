import UIKit

class LoginScreen: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo1")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TryIT"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Virtual Try-On & Measurements"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mobileNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Mobile Number"
        textField.keyboardType = .numberPad
        textField.autocapitalizationType = .none
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
        return button
    }()
    
    private let changeNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Number", for: .normal)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New here? Create new Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let otpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true // Initially hidden
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true // Initially hidden
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(mobileNumberTextField)
        view.addSubview(sendOtpButton)
        view.addSubview(otpStackView)
        view.addSubview(buttonStackView)
        view.addSubview(createAccountButton)
        
        otpStackView.addArrangedSubview(otpTextField)
        buttonStackView.addArrangedSubview(changeNumberButton)
        buttonStackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            mobileNumberTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            mobileNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mobileNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            sendOtpButton.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 16),
            sendOtpButton.leadingAnchor.constraint(equalTo: mobileNumberTextField.leadingAnchor),
            sendOtpButton.trailingAnchor.constraint(equalTo: mobileNumberTextField.trailingAnchor),
            sendOtpButton.heightAnchor.constraint(equalToConstant: 50),
            
            otpStackView.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 8),
            otpStackView.leadingAnchor.constraint(equalTo: mobileNumberTextField.leadingAnchor),
            otpStackView.trailingAnchor.constraint(equalTo: mobileNumberTextField.trailingAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 8),
            buttonStackView.leadingAnchor.constraint(equalTo: mobileNumberTextField.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: mobileNumberTextField.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 16),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        sendOtpButton.addTarget(self, action: #selector(sendOtpTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        changeNumberButton.addTarget(self, action: #selector(changeNumberTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
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
                self.mobileNumberTextField.isEnabled = false
                self.otpStackView.isHidden = false
                self.otpTextField.isHidden = false
                self.buttonStackView.isHidden = false
                self.loginButton.isHidden = false
                self.changeNumberButton.isHidden = false
                self.otpTextField.becomeFirstResponder()
                
                AuthUtility.shared.showAlert(on: self, message: "OTP sent successfully!", title: "Success")
            } else {
                AuthUtility.shared.showAlert(on: self, message: error ?? "Failed to send OTP.")
            }
        }
    }
    
    @objc private func loginTapped() {
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty,
              let otp = otpTextField.text, !otp.isEmpty else {
            AuthUtility.shared.showAlert(on: self, message: "Please enter mobile number and OTP.")
            return
        }
        
        createAccountButton.isHidden = true
        
        AuthUtility.shared.verifyOtp(mobileNumber: mobileNumber, otp: otp) { success, error in
            if success {
                self.performSegue(withIdentifier: "NavigateToTabBar", sender: self)
            } else {
                AuthUtility.shared.showAlert(on: self, message: error ?? "Invalid OTP.")
                self.createAccountButton.isHidden = false
            }
        }
    }
    
    @objc private func changeNumberTapped() {
        mobileNumberTextField.isEnabled = true
        mobileNumberTextField.becomeFirstResponder()
        
        otpStackView.isHidden = true
        buttonStackView.isHidden = true
        sendOtpButton.isHidden = false
    }
    
    @objc private func createAccountTapped() {
        let registerVC = RegisterScreen()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
}
