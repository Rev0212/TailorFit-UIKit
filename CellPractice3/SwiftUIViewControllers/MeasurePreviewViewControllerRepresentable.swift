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
    
    func makeUIViewController(context: Context) -> MeasurePreviewViewController {
        // Get reference to main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate MeasurePreviewViewController from storyboard
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MeasurePreviewViewController") as? MeasurePreviewViewController else {
            fatalError("MeasurePreviewViewController not found in Storyboard")
        }
        
        // Set the measurement data
        viewController.fetchedMeasurements = measurement
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MeasurePreviewViewController, context: Context) {
        // Update the view controller when measurement changes
        uiViewController.fetchedMeasurements = measurement
        
        // Trigger view update if needed
        if uiViewController.isViewLoaded {
            uiViewController.displayProcessedImage()
        }
    }
}
