//
//  HelpSupportViewController.swift
//  CellPractice3
//
//  Created by admin29 on 18/03/25.
//


//  HelpSupportViewController.swift


import UIKit

class HelpSupportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let faqData: [(question: String, answer: String)] = [
        ("How does the Virtual Try-On feature work?", "Our AI analyzes your uploaded image and overlays clothing items realistically."),
        ("Do I need special equipment for the try-on?", "No! TRY IT works with just your smartphone’s camera—no additional hardware needed."),
        ("Why is my try-on result not accurate?", "Ensure you upload a clear, well-lit photo with a straight posture."),
        ("How does the Body Measurement feature work?", "Our AI scans your uploaded image and extracts body measurements."),
        ("Is my data stored after measuring my body?", "No! TRY IT does not store any of your personal data or images."),
        ("Does TRY IT sell clothes?", "No. TRY IT is not an online store but a virtual fitting room."),
        ("Can I buy clothes directly from the app?", "No, but we provide links to official retailers."),
        ("Is my data safe with TRY IT?", "Absolutely! We do not store or share your images or measurements."),
        ("How can I delete my account and data?", "Since we do not store personal data, there's no account deletion required."),
        ("How can I contact customer support?", "You can reach out via email at support@tryitapp.com.")
    ]

    var expandedIndexSet: IndexSet = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Help & Support"
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return faqData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedIndexSet.contains(section) ? 2 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 0

        if indexPath.row == 0 {
            cell.textLabel?.text = "\(indexPath.section + 1). " + faqData[indexPath.section].question
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.backgroundColor = .white
        } else {
            cell.textLabel?.text = "✅ " + faqData[indexPath.section].answer
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = .darkGray
            cell.backgroundColor = .white
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if expandedIndexSet.contains(indexPath.section) {
                expandedIndexSet.remove(indexPath.section)
            } else {
                expandedIndexSet.insert(indexPath.section)
            }
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
