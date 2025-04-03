//
//  CameraViewController.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//

import UIKit
import SwiftUI
class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CameraViewController")
        // Do any additional setup after loading the view.
        extractView()
    }
    
    func extractView() {
        let hostView = UIHostingController(rootView: ContentView())
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(hostView.view)
        
        let constraints: [NSLayoutConstraint] = [
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostView.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        self.view.addConstraints(constraints)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
