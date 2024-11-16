//
//  SavedDisplayCellTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//

import UIKit

class SavedDisplayCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var valueLabel: UILabel!
       
       override func awakeFromNib() {
           super.awakeFromNib()
           // Custom initialization code if needed
       }
       
       func configure(title: String, value: String) {
           titleLabel.text = title
           valueLabel.text = value
       }
    
}
