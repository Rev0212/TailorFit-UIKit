import UIKit

class LoadingAnimationView: UIView {
    private let sphere1 = UIImageView()
    private let sphere2 = UIImageView()
    private var smallerCircles: [UIView] = []
    private var displayLink: CADisplayLink?
    private var centralCircle: UIView?
    private let magicLabel = UILabel()
    
    private var orbitAngleOffset: CGFloat = 0
    private var orbitRadius: CGFloat = 150 // Increased orbit radius
    private var isAligning = false
    private var isDispersing = false
    
    init(frame: CGRect, image1: UIImage, image2: UIImage) {
        super.init(frame: frame)
        setupView(image1: image1, image2: image2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(image1: UIImage, image2: UIImage) {
        backgroundColor = .black
        
        let sphereSize: CGFloat = 100
        sphere1.frame = CGRect(x: 50, y: bounds.midY - sphereSize / 2, width: sphereSize, height: sphereSize)
        sphere1.layer.cornerRadius = sphereSize / 2
        sphere1.image = image1
        sphere1.contentMode = .scaleAspectFill
        sphere1.clipsToBounds = true
        addSubview(sphere1)
        
        sphere2.frame = CGRect(x: bounds.width - sphereSize - 50, y: bounds.midY - sphereSize / 2, width: sphereSize, height: sphereSize)
        sphere2.layer.cornerRadius = sphereSize / 2
        sphere2.image = image2
        sphere2.contentMode = .scaleAspectFill
        sphere2.clipsToBounds = true
        addSubview(sphere2)
        
        setupMagicLabel()
        startCollisionAnimation()
    }
    
    private func setupMagicLabel() {
           magicLabel.translatesAutoresizingMaskIntoConstraints = false
           addSubview(magicLabel)
           
           magicLabel.text = "Creating Magic..."
           magicLabel.textColor = .white
           magicLabel.font = .systemFont(ofSize: 20, weight: .medium)
           magicLabel.textAlignment = .center
           magicLabel.alpha = 0
           
           NSLayoutConstraint.activate([
               magicLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
               magicLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
               magicLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
               magicLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
           ])
           
           // Animate the label
           UIView.animate(withDuration: 1.0, delay: 0.5, options: [.autoreverse, .repeat]) {
               self.magicLabel.alpha = 1
           }
       }
    
    private func startCollisionAnimation() {
        UIView.animate(withDuration: 2.5, animations: {
            self.sphere1.center.x = self.bounds.midX - 0
            self.sphere2.center.x = self.bounds.midX + 0
        }) { _ in
            self.handleCollision()
        }
    }
    
    private func handleCollision() {
        UIView.animate(withDuration: 0.5, animations: {
            self.sphere1.alpha = 0
            self.sphere2.alpha = 0
        }) { _ in
            self.sphere1.removeFromSuperview()
            self.sphere2.removeFromSuperview()
            self.spawnSmallerCircles()
        }
    }
    
    private func spawnSmallerCircles() {
        let circleCount = 25
        let circleSize: CGFloat = 15
        let centralCircleSize: CGFloat = 100  // Big central circle
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Create central circle (UIView)
        centralCircle = UIView(frame: CGRect(x: centerPoint.x - centralCircleSize / 2, y: centerPoint.y - centralCircleSize / 2, width: centralCircleSize, height: centralCircleSize))
        centralCircle?.layer.cornerRadius = centralCircleSize / 2
        centralCircle?.backgroundColor = .white
        addSubview(centralCircle!)
        
        for _ in 0..<circleCount {
            let circle = UIView(frame: CGRect(x: centerPoint.x, y: centerPoint.y, width: circleSize, height: circleSize))
            circle.backgroundColor = randomVibrantColor()
            circle.layer.cornerRadius = circleSize / 2
            addSubview(circle)
            smallerCircles.append(circle)
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            for circle in self.smallerCircles {
                let randomAngle = CGFloat.random(in: 0...(2 * .pi))
                let randomDistance = CGFloat.random(in: 80...200)
                circle.center = CGPoint(
                    x: centerPoint.x + randomDistance * cos(randomAngle),
                    y: centerPoint.y + randomDistance * sin(randomAngle)
                )
            }
        }) { _ in
            self.alignCirclesIntoOrbit()
        }
    }
    
    private func alignCirclesIntoOrbit() {
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        isAligning = true
        
        UIView.animate(withDuration: 2.0, animations: {
            for (index, circle) in self.smallerCircles.enumerated() {
                let angle = CGFloat(index) * (2 * .pi / CGFloat(self.smallerCircles.count))
                circle.center = CGPoint(
                    x: centerPoint.x + self.orbitRadius * cos(angle),
                    y: centerPoint.y + self.orbitRadius * sin(angle)
                )
            }
        }) { _ in
            self.startOrbitingEffect()
        }
    }
    func startOrbitingEffect() {
        startPulseAnimation() // Start the pulsing animation
        
        // Start orbit animation
        displayLink = CADisplayLink(target: self, selector: #selector(animateOrbit))
        displayLink?.add(to: .current, forMode: .common)
    }

    
    
//    private func startOrbitingEffect() {
//        startPulseAnimation() // Start the pulsing animation
//        displayLink = CADisplayLink(target: self, selector: #selector(animateOrbit))
//        displayLink?.add(to: .current, forMode: .common)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.isDispersing = true
//            self.expandAndFadeCentralCircle() // Expand and fade effect
//        }
//    }
    
     func stopOrbitingEffect() {
        displayLink?.invalidate()
        displayLink = nil

        // Remove smaller circles and central circle
        for circle in smallerCircles {
            circle.removeFromSuperview()
        }
        centralCircle?.removeFromSuperview()
    }

    
    private func expandAndFadeCentralCircle() {
           guard let centralCircle = centralCircle else { return }
           
           centralCircle.layer.removeAllAnimations()
           centralCircle.layer.removeAnimation(forKey: "pulse")
           
           let screenSize = UIScreen.main.bounds.size
           let maxDimension = max(screenSize.width, screenSize.height)
           let currentSize = centralCircle.bounds.width
           let scaleRequired = (maxDimension * 2) / currentSize
           
           UIView.animate(withDuration: 3.5, delay: 0, options: [.curveEaseOut], animations: {
               centralCircle.transform = CGAffineTransform(scaleX: scaleRequired, y: scaleRequired)
               centralCircle.alpha = 0
               self.magicLabel.alpha = 0  // Fade out the label
           }) { _ in
               centralCircle.removeFromSuperview()
               self.magicLabel.removeFromSuperview()
           }
       }
    
    private func startPulseAnimation() {
        guard let centralCircle = centralCircle else { return }

        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.duration = 0.8
        pulse.autoreverses = true
        pulse.repeatCount = .infinity

        centralCircle.layer.add(pulse, forKey: "pulse")
    }
    
    @objc private func animateOrbit() {
        guard let centralCircle = centralCircle else { return }
        let centerPoint = centralCircle.center
        
        orbitAngleOffset += 0.03
        
        for (index, circle) in smallerCircles.enumerated() {
            let baseAngle = CGFloat(index) * (2 * .pi / CGFloat(smallerCircles.count))
            let angle = baseAngle + orbitAngleOffset
            
            if isDispersing {
                circle.center = CGPoint(
                    x: circle.center.x + 2 * cos(angle),
                    y: circle.center.y + 2 * sin(angle)
                )
                circle.alpha -= 0.015
            } else {
                circle.center = CGPoint(
                    x: centerPoint.x + orbitRadius * cos(angle),
                    y: centerPoint.y + orbitRadius * sin(angle)
                )
            }
        }
        
        if isDispersing, let firstCircle = smallerCircles.first, firstCircle.alpha <= 0 {
            displayLink?.invalidate()
            displayLink = nil
            for circle in smallerCircles {
                circle.removeFromSuperview()
            }
            centralCircle.removeFromSuperview()
        }
    }
    
    private func randomVibrantColor() -> UIColor {
        let colors: [UIColor] = [
            .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemBlue, .systemPurple, .systemPink
        ]
        return colors.randomElement()!
    }
}

