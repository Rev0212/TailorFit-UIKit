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

    // Create the view controller and pass the measurement data
    func makeUIViewController(context: Context) -> MeasurePreviewViewController {
        let viewController = MeasurePreviewViewController()
        // Pass the measurement data to the view controller if needed
        viewController.fetchedMeasurements = measurement
        return viewController
    }

    // Update the view controller with any new data when the SwiftUI state changes
    func updateUIViewController(_ uiViewController: MeasurePreviewViewController, context: Context) {
        // Update the measurement or other properties of MeasurePreviewViewController if necessary
        uiViewController.fetchedMeasurements = measurement
    }
}
