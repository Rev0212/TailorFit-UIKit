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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MeasurePreviewViewController") as? MeasurePreviewViewController else {
            fatalError("MeasurePreviewViewController not found in Storyboard")
        }
        
        // Set the measurement data
        viewController.fetchedMeasurements = measurement
        print("Passing measurement to MeasurePreviewViewController: \(String(describing: measurement))")
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MeasurePreviewViewController, context: Context) {
        // Update the measurement data
        uiViewController.fetchedMeasurements = measurement
        print("Updating MeasurePreviewViewController with new measurement: \(String(describing: measurement))")
        
        // Refresh the UI
        if uiViewController.isViewLoaded {
            uiViewController.displayProcessedImage()
        }
    }
}
