//
//  AboutTheAppViewController.swift
//  CellPractice3
//
//  Created by admin29 on 18/03/25.
//


//  AboutTheAppViewController.swift

import UIKit
import WebKit

class AboutTheAppViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let sections = ["About", "Legal"]
    private let legalItems = ["Privacy Policy", "Terms & Conditions"]
    private let urls = [
        "https://docs.google.com/document/d/privacy-policy", // Replace with actual Privacy Policy URL
        "https://docs.google.com/document/d/terms-conditions" // Replace with actual Terms URL
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        title = "About"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appIcon = UIImageView(image: UIImage(named: "logo1"))
        appIcon.contentMode = .scaleAspectFit
        appIcon.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        appIcon.center.x = view.center.x
        tableView.tableHeaderView = appIcon
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AboutTheAppViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : legalItems.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .white

        if indexPath.section == 0 {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = """
            TryIt
            Version 1.0

            Transform your shopping experience with TryIt - the revolutionary virtual fitting room in your pocket.

            Try clothes before you buy, get perfect size recommendations, and shop with confidence.

            © 2025 SRMIST.
            """
            cell.selectionStyle = .none
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = legalItems[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let webVC = WebViewController()
            webVC.title = legalItems[indexPath.row]
            webVC.urlString = urls[indexPath.row]
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

class WebViewController: UIViewController {
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebViewController: WKNavigationDelegate {}

