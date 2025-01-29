import UIKit

protocol SaveInputTableViewCellDelegate: AnyObject {
    func saveInputCellDidUpdateValue(_ cell: SaveInputTableViewCell, value: String)
}

class SaveInputTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: SaveInputTableViewCellDelegate?
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let valueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .right
        textField.placeholder = "Enter value"  // Default placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter value",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        return textField
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueTextField)
        valueTextField.delegate = self
        
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            // Text Field Constraints
            valueTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            valueTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Configuration Methods
    func configure(title: String, value: String, placeholder: String? = nil, delegate: SaveInputTableViewCellDelegate) {
        self.titleLabel.text = title
        self.valueTextField.text = value
        self.delegate = delegate
        
        // Set custom placeholder if provided
        if let placeholder = placeholder {
            self.valueTextField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            )
        }
    }
    
    func configureCellAppearance(isFirst: Bool, isLast: Bool) {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        if isFirst {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            layer.maskedCorners = []
        }
    }
}

// MARK: - UITextFieldDelegate
extension SaveInputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.saveInputCellDidUpdateValue(self, value: textField.text ?? "")
    }
}
