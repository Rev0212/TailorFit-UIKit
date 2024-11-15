//
//  ProfileTableViewCell.swift
//  CellPractice3
//
//  Created by admin29 on 12/11/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set profile image as circular
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        // Configure profile name font and color
        profileName.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        profileName.textColor = .black
        
        // Additional styling
        self.selectionStyle = .none // Remove selection highlight
        self.accessoryType = .disclosureIndicator // Add a right arrow like in iOS Settings
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
