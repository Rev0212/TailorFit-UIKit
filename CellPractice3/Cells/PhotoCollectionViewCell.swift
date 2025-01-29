import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Add imageView to the cell's contentView
        contentView.addSubview(imageView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Style the contentView
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        // Add border
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray2.cgColor
        
        // Add shadow to the cell (not contentView)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 0.2
//        layer.masksToBounds = false
        
        // Important: Set the corner radius on the cell's layer as well
        // This ensures the shadow follows the rounded corners
        layer.cornerRadius = 8
        
        // Add some padding between cells
        contentView.clipsToBounds = true
        backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    func setSelected(_ selected: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
            contentView.layer.borderWidth = 1.0
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        setSelected(false)
    }
}
