//
//  PhotoCell.swift
//  CellPractice3
//
//  Created by admin29 on 11/03/25.
//


import UIKit

class PhotoCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let checkmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 12
        view.isHidden = true
        
        // Add checkmark
        let checkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        checkImageView.tintColor = .white
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checkImageView)
        
        NSLayoutConstraint.activate([
            checkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 15),
            checkImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        return view
    }()
    
    var isInSelectionMode: Bool = false {
        didSet {
            updateSelectionAppearance()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(checkmarkView)
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmarkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    private func updateSelectionAppearance() {
        if isInSelectionMode {
            checkmarkView.isHidden = !isSelected
            
            // Add slight dimming when selected
            if isSelected {
                let overlayView = UIView(frame: contentView.bounds)
                overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                overlayView.tag = 100
                contentView.addSubview(overlayView)
                contentView.bringSubviewToFront(checkmarkView)
            } else {
                contentView.viewWithTag(100)?.removeFromSuperview()
            }
        } else {
            checkmarkView.isHidden = true
            contentView.viewWithTag(100)?.removeFromSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        checkmarkView.isHidden = true
        contentView.viewWithTag(100)?.removeFromSuperview()
        isInSelectionMode = false
    }
}
