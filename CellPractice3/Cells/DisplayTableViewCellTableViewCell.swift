//
//  DisplayTableViewCellTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class DisplayTableViewCellTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
        private let valueLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            contentView.backgroundColor = .systemBackground
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(valueLabel)
            
            valueLabel.textAlignment = .right
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
                
                contentView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        func configure(title: String, value: String) {
            titleLabel.text = title
            valueLabel.text = value
        }
    }
