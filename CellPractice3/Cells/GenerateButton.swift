import UIKit

class GenerateButton: UIButton {
    // MARK: - Properties
    
    // Gradient colors
    var gradientColors: [UIColor] = [
        UIColor(red: 0/255, green: 157/255, blue: 255/255, alpha: 1),  // Blue
        UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1)   // Purple
    ] {
        didSet {
            gradientLayer.colors = gradientColors.map { $0.cgColor }
        }
    }
    
    // Glow color
    var glowColor: UIColor = UIColor(red: 0/255, green: 157/255, blue: 255/255, alpha: 0.6) {
        didSet {
            glowLayer.shadowColor = glowColor.cgColor
        }
    }
    
    // Sparkle icon
    var sparkleIcon: UIImage? = UIImage(systemName: "sparkle") {
        didSet {
            sparkleImageView.image = sparkleIcon
        }
    }
    
    // Button text
    var buttonText: String = "Generate" {
        didSet {
            label.text = buttonText
        }
    }
    
    // MARK: - Private Properties
    private let gradientLayer = CAGradientLayer()
    private let glowLayer = CALayer()
    private let contentStack = UIStackView()
    private let sparkleImageView = UIImageView()
    private let label = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        // Base setup
        layer.cornerRadius = 24
        clipsToBounds = false // Allow glow to extend outside
        
        // Gradient background
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 24
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Glow effect
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = glowColor.cgColor
        glowLayer.shadowOffset = .zero
        glowLayer.shadowOpacity = 0.8
        glowLayer.shadowRadius = 15
        glowLayer.cornerRadius = 24
        glowLayer.shouldRasterize = true
        glowLayer.rasterizationScale = UIScreen.main.scale
        layer.insertSublayer(glowLayer, at: 0)
        
        // Content stack
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.isUserInteractionEnabled = false
        addSubview(contentStack)
        
        // Sparkle icon
        sparkleImageView.image = sparkleIcon
        sparkleImageView.tintColor = .white
        sparkleImageView.contentMode = .scaleAspectFit
        sparkleImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        sparkleImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        contentStack.addArrangedSubview(sparkleImageView)
        
        // Text label
        label.text = buttonText
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        contentStack.addArrangedSubview(label)
        
        // Layout
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 48)
        ])
        
        // Accessibility
        isAccessibilityElement = true
        accessibilityLabel = buttonText
        accessibilityTraits = .button
        
        // Add hover animation
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        glowLayer.frame = bounds
    }
    
    // MARK: - Animations
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.glowLayer.shadowOpacity = 0.4
        })
        addRippleEffect()
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = .identity
            self.glowLayer.shadowOpacity = 0.8
        })
    }
    
    // Ripple effect
    private func addRippleEffect() {
        let rippleLayer = CAShapeLayer()
        rippleLayer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        rippleLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        rippleLayer.cornerRadius = layer.cornerRadius
        rippleLayer.opacity = 0
        layer.addSublayer(rippleLayer)
        
        let rippleAnimation = CABasicAnimation(keyPath: "transform.scale")
        rippleAnimation.fromValue = 1.0
        rippleAnimation.toValue = 1.2
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rippleAnimation, opacityAnimation]
        groupAnimation.duration = 0.4
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        rippleLayer.add(groupAnimation, forKey: "ripple")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            rippleLayer.removeFromSuperlayer()
        }
    }
    
    // Breathing glow animation
    func startBreathingAnimation() {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        breathingAnimation.fromValue = 0.8
        breathingAnimation.toValue = 0.4
        breathingAnimation.duration = 1.5
        breathingAnimation.autoreverses = true
        breathingAnimation.repeatCount = .infinity
        breathingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        glowLayer.add(breathingAnimation, forKey: "breathing")
    }
    
    func stopBreathingAnimation() {
        glowLayer.removeAnimation(forKey: "breathing")
    }
}
