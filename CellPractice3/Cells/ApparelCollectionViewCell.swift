class ApparelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true  // Changed from masksToBounds to clipsToBounds
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        // First, ensure the cell itself doesn't clip
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        contentView.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Container constraints - reduced padding to make borders more visible
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // ImageView constraints
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30),
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupShadow() {
        // Add shadow to the container instead of the cell
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowRadius = 6
        container.layer.masksToBounds = false
        
        // Important: Create a shadow path for better performance
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds, 
                                                cornerRadius: container.layer.cornerRadius).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update shadow path when the bounds change
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds, 
                                                cornerRadius: container.layer.cornerRadius).cgPath
    }
    
    // MARK: - Public Methods
    func configure(with image: UIImage?, title: String?) {
        imageView.image = image
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}