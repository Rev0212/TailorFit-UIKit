//
//  SettingsViewController.swift
//  CellPractice3
//
//  Created by admin29 on 12/11/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var iconNames = ["person.fill", "translate", "tag.fill"]
    var SettingNames = ["People", "Language", "Brand"]
    var profileImage = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Profile TableView cell
        let nib2 = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        profileTableView.register(nib2, forCellReuseIdentifier: "ProfileCell")
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.rowHeight = 80
        
        // Register Settings TableView cell
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingsCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileTableView {
            return 1 // Profile table view has only 1 row
        } else {
            return SettingNames.count // Settings table view has rows based on SettingNames count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profileTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
            cell.profileName.text = "Hariharan"
            tableView.separatorStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingsLabel.text = SettingNames[indexPath.row]
            cell.iconImage.image = UIImage(systemName: iconNames[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
                if tableView == profileTableView {
                    navigateToProfileVC()
                }
    }
    
    private func navigateToProfileVC() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                navigationController?.pushViewController(profileVC, animated: true)
            }
            print("Nabigated to Profile View Controller")
        }
}
