//
//  SettingsTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 12/11/24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
