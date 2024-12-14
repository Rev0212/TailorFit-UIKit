//
//  LoadingAnimationView.swift
//  CellPractice3
//
//  Created by admin29 on 19/11/24.
//


import UIKit

class LoadingAnimationView: UIView {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let loadingLabel = UILabel()
    private let progressView = UIProgressView()
    private var rotationAnimation: CABasicAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Container setup
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        addSubview(containerView)
        
        // Icon setup
        iconImageView.image = UIImage(systemName:"gear")
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
        
        // Label setup
        loadingLabel.text = "Generating your virtual try-on..."
        loadingLabel.textAlignment = .center
        loadingLabel.font = .systemFont(ofSize: 16, weight: .medium)
        loadingLabel.textColor = .label
        loadingLabel.numberOfLines = 0
        containerView.addSubview(loadingLabel)
        
        // Progress view setup
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        containerView.addSubview(progressView)
        
        setupConstraints()
        startAnimating()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Icon constraints
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Label constraints
            loadingLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            loadingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Progress view constraints
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    func startAnimating() {
        // Rotate animation for icon
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        iconImageView.layer.add(rotation, forKey: "rotationAnimation")
        
        // Progress view animation
        progressView.progress = 0.0
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.progressView.progress = 1.0
        })
    }
    
    func stopAnimating() {
        iconImageView.layer.removeAllAnimations()
        progressView.layer.removeAllAnimations()
    }
}
