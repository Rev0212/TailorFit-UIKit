//
//  for.swift
//  CellPractice3
//
//  Created by admin29 on 16/11/24.
//


import SwiftUI
import UIKit

// Define the Representable struct for MeasurePreviewViewController
struct MeasurePreviewViewControllerRepresentable: UIViewControllerRepresentable {
    var measurement: BodyMeasurement?
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MeasurePreviewViewController") as? MeasurePreviewViewController else {
            fatalError("MeasurePreviewViewController not found in Storyboard")
        }
        
        // Set the measurement data
        viewController.fetchedMeasurements = measurement
        print("Passing measurement to MeasurePreviewViewController: \(String(describing: measurement))")
        
        // Embed the view controller in a navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update the measurement data
        if let viewController = uiViewController.viewControllers.first as? MeasurePreviewViewController {
            viewController.fetchedMeasurements = measurement
            print("Updating MeasurePreviewViewController with new measurement: \(String(describing: measurement))")
            
            // Refresh the UI
            if viewController.isViewLoaded {
                viewController.displayProcessedImage()
            }
        }
    }
}
