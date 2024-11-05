

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    static let identifier = "DemoTableViewCell"
    
    enum CellStyle {
        case detail
        case size
        case measurement
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DemoTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        // Title Label styling
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .label
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // Value TextField styling
        valueTextField.font = .systemFont(ofSize: 17)
        valueTextField.textColor = .label
        valueTextField.borderStyle = .none
        valueTextField.textAlignment = .left // Changed to left alignment
        valueTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Add a minimum width constraint to the titleLabel
        if let constraints = titleLabel.constraints.first(where: { $0.firstAttribute == .width }) {
            constraints.constant = 100 // Adjust this value based on your needs
        } else {
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        }
    }
    
    func configure(title: String, value: String, style: CellStyle) {
        titleLabel.text = title
        valueTextField.text = value
        
        switch style {
        case .detail:
            valueTextField.isEnabled = false
        case .size:
            valueTextField.isEnabled = true
            valueTextField.keyboardType = .default
        case .measurement:
            valueTextField.isEnabled = true
            valueTextField.keyboardType = .decimalPad
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
            layer.cornerRadius = 0
        }
    }
}
