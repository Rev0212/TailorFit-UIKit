
import UIKit




class SaveInputTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SaveInputCell"

    let titleLabel = UILabel()
    let inputTextField = UITextField()
    weak var delegate: SaveInputTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(inputTextField)

        titleLabel.font = .systemFont(ofSize: 16)
        inputTextField.font = .systemFont(ofSize: 16)
        inputTextField.textAlignment = .right
        inputTextField.borderStyle = .none

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            inputTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            inputTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func configure(title: String, value: String, placeholder: String, delegate: SaveInputTableViewCellDelegate?) {
        titleLabel.text = title
        inputTextField.text = value
        inputTextField.placeholder = placeholder
        self.delegate = delegate
    }

    func configureCellAppearance(isFirst: Bool, isLast: Bool) {
        backgroundColor = .white
        selectionStyle = .none
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.saveInputCellDidUpdateValue(self, value: textField.text ?? "")
    }
}
