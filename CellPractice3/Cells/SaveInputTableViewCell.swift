class SaveInputTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SaveInputCell" // Static reuse identifier
    
    let titleLabel = UILabel()
    let textField = UITextField()
    
    weak var delegate: SaveInputTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configure titleLabel
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Configure textField
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        contentView.addSubview(textField)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 80),
            
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, value: String, delegate: SaveInputTableViewCellDelegate) {
        titleLabel.text = title
        textField.text = value
        self.delegate = delegate
    }
    
    func configureCellAppearance(isFirst: Bool, isLast: Bool) {
        // Customize cell appearance (e.g., rounded corners)
        if isFirst {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            layer.maskedCorners = []
        }
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.saveInputCellDidUpdateValue(self, value: textField.text ?? "")
    }
}