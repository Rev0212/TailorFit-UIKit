//
//  LoadingAnimation.swift
//  CellPractice3
//
//  Created by admin29 on 28/01/25.
//


import UIKit

class LoadingAnimation {
    
    // MARK: - Properties
    private let pulsingLayer = CAShapeLayer()
    private let rotatingLayer = CAShapeLayer()
    private let loadingView: UIView
    private let loadingLabel: UILabel
    
    // MARK: - Initialization
    init(loadingView: UIView, loadingLabel: UILabel) {
        self.loadingView = loadingView
        self.loadingLabel = loadingLabel
        setupLoadingAnimation()
    }
    
    // MARK: - Setup
    private func setupLoadingAnimation() {
        // Setup loading view
        loadingView.backgroundColor = .clear
        
        // Setup pulsing circle
        let pulsingPath = UIBezierPath(arcCenter: loadingView.center,
                                     radius: 50,
                                     startAngle: 0,
                                     endAngle: 2 * .pi,
                                     clockwise: true)
        
        pulsingLayer.path = pulsingPath.cgPath
        pulsingLayer.strokeColor = UIColor.lightGray.cgColor
        pulsingLayer.fillColor = UIColor.clear.cgColor
        pulsingLayer.lineWidth = 2
        loadingView.layer.addSublayer(pulsingLayer)
        
        // Setup rotating arc
        let rotatingPath = UIBezierPath(arcCenter: loadingView.center,
                                      radius: 25,
                                      startAngle: 0,
                                      endAngle: 2 * .pi * 0.7,
                                      clockwise: true)
        
        rotatingLayer.path = rotatingPath.cgPath
        rotatingLayer.strokeColor = UIColor.systemBlue.cgColor
        rotatingLayer.fillColor = UIColor.clear.cgColor
        rotatingLayer.lineWidth = 3
        loadingView.layer.addSublayer(rotatingLayer)
        
        // Setup label
        loadingLabel.text = "Generating Image..."
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
    }
    
    // MARK: - Animation
    func startLoadingAnimation() {
        // Pulsing animation
        let pulsingAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsingAnimation.fromValue = 1.0
        pulsingAnimation.toValue = 1.5
        pulsingAnimation.duration = 1.0
        pulsingAnimation.repeatCount = .infinity
        pulsingAnimation.autoreverses = false
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 1.0
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = false
        
        pulsingLayer.add(pulsingAnimation, forKey: "pulsing")
        pulsingLayer.add(opacityAnimation, forKey: "opacity")
        
        // Rotating animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        rotatingLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    func stopLoadingAnimation() {
        // Stop animations
        pulsingLayer.removeAllAnimations()
        rotatingLayer.removeAllAnimations()
        
        // Hide loading elements
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.loadingView.alpha = 0
            self?.loadingLabel.alpha = 0
        }
    }
}
