//
//  ImageDetailViewController.swift
//  CellPractice3
//
//  Created by admin29 on 11/03/25.
//

import UIKit
//
//protocol ImageDetailViewControllerDelegate: AnyObject {
//    func didDeleteImage(at index: Int)
//    func didLikeImage(at index: Int)
//}



class ImageDetailViewController: UIViewController {
    private let imageView = UIImageView()
    private let deleteButton = UIButton(type: .system)
    private let likeButton = UIButton(type: .system)
    
    private let image: UIImage
    private let index: Int
    private var isLiked: Bool = false
    weak var delegate: ImageDetailViewControllerDelegate?
    
    init(image: UIImage, index: Int) {
        self.image = image
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupImageView()
        setupButtons()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }
    
    private func setupImageView() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupButtons() {
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .systemRed
        likeButton.addTarget(self, action: #selector(likeImage), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [deleteButton, likeButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func shareImage() {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc private func deleteImage() {
        delegate?.didDeleteImage(at: index)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func likeImage() {
        isLiked.toggle()
        likeButton.isSelected = isLiked
        delegate?.didLikeImage(at: index)
    }
}
