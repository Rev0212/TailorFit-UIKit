import UIKit

class ImageDetailViewController: UIViewController {
    private let resultImageView = UIImageView()
    private let smallImagesStackView = UIStackView()
    private let mainImageView = UIImageView()
    private let apparelImageView = UIImageView()
    
    private let mainImage: UIImage
    private let apparelImage: UIImage
    private let resultImage: UIImage
    private let index: Int
    
    weak var delegate: ImageDetailViewControllerDelegate?
    
    init(mainImage: UIImage, apparelImage: UIImage, resultImage: UIImage, index: Int) {
        self.mainImage = mainImage
        self.apparelImage = apparelImage
        self.resultImage = resultImage
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        self.edgesForExtendedLayout = []
    }
    
    private func configureImageView(_ imageView: UIImageView) {
           imageView.contentMode = .scaleAspectFit
           imageView.backgroundColor = .white
           imageView.clipsToBounds = true
//           imageView.layer.cornerRadius = 12
//           imageView.layer.borderWidth = 1
           imageView.layer.borderColor = UIColor.systemGray5.cgColor
       }

    
    private func setupViews() {
            // Configure result image view
            resultImageView.translatesAutoresizingMaskIntoConstraints = false
            configureImageView(resultImageView)
            resultImageView.image = resultImage
            
            // Configure small images stack view
            smallImagesStackView.translatesAutoresizingMaskIntoConstraints = false
            smallImagesStackView.axis = .horizontal
            smallImagesStackView.distribution = .fillEqually
            smallImagesStackView.spacing = 16
            
            // Configure person and apparel image views
            [mainImageView, apparelImageView].forEach { imageView in
                configureImageView(imageView)
            }
            
            mainImageView.image = mainImage
            apparelImageView.image = apparelImage
            
            smallImagesStackView.addArrangedSubview(mainImageView)
            smallImagesStackView.addArrangedSubview(apparelImageView)
            
            view.addSubview(resultImageView)
            view.addSubview(smallImagesStackView)
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Result image constraints
            resultImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            resultImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            
            // Small images stack view constraints
            smallImagesStackView.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 16),
            smallImagesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            smallImagesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            smallImagesStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareImage)
        )
    }
    
    @objc private func shareImage() {
        let activityViewController = UIActivityViewController(
            activityItems: [resultImage, mainImage, apparelImage],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}
