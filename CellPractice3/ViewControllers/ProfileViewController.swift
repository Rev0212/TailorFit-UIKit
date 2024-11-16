//
//  ProfileViewController.swift
//  CellPractice3
//
//  Created by admin29 on 13/11/24.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    var ProfileDetailTitles = ["DOB", "Country", "Size"]
    var ProfileDetailDescriptions = ["12/1/2024", "India", "M,XL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileDetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfileDetailCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        styleSignOutButton()
    }
    
    
    private func styleSignOutButton() {

        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signOutButton.layer.cornerRadius = 10
        signOutButton.layer.masksToBounds = true
        
        // Optionally, add a shadow to enhance the appearance
        signOutButton.layer.shadowColor = UIColor.black.cgColor
        signOutButton.layer.shadowOpacity = 0.1
        signOutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        signOutButton.layer.shadowRadius = 4
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileDetailTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailCell", for: indexPath) as! ProfileDetailsTableViewCell
        cell.label1.text = ProfileDetailTitles[indexPath.row]
        cell.label2.text = ProfileDetailDescriptions[indexPath.row]
        cell.backgroundColor = UIColor.secondarySystemGroupedBackground
             cell.layer.cornerRadius = 10
             cell.layer.masksToBounds = true
        return cell
    }
    
   

}
