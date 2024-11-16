//
//  SaveInputTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class SaveInputTableViewCell: UITableViewCell {

        
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var inputField: UITextField!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
        private func setupUI() {
            contentView.backgroundColor = .systemBackground
            inputField.borderStyle = .none
            inputField.textAlignment = .right
        }
        
        func configure(title: String, value: String, delegate: UITextFieldDelegate) {
            titleLabel.text = title
            inputField.text = value
            inputField.delegate = delegate
            inputField.placeholder = "Enter \(title.lowercased())"
        }
        
        func configureCellAppearance(isFirst: Bool, isLast: Bool) {
            layer.cornerRadius = isFirst || isLast ? 10 : 0
            layer.maskedCorners = isFirst ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
                isLast ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
            clipsToBounds = true
        }
    }
