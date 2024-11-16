//
//  SaveDisplayTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class SaveDisplayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        valueLabel.textAlignment = .right
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    func configureCellAppearance(isFirst: Bool, isLast: Bool) {
        layer.cornerRadius = isFirst || isLast ? 10 : 0
        layer.maskedCorners = isFirst ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
        isLast ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
        clipsToBounds = true
    }
    
    // Configure the view for the selected state
}
