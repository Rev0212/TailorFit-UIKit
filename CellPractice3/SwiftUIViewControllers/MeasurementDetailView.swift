//
//  MeasurementDetailView.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//
import SwiftUI
import Foundation

struct MeasurementDetailView: View {
    let measurement: BodyMeasurement
    @Environment(\.dismiss) private var dismiss
    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            List {
                if let processedImage = measurement.processedImage,
                   let url = URL(string: processedImage) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                }
                
                Section("Upper Body") {
                    MeasurementRow(title: "Chest", value: measurement.chestCircumference)
                    MeasurementRow(title: "Waist", value: measurement.waistCircumference)
                    MeasurementRow(title: "Hip", value: measurement.hipCircumference)
                }
                
                Section("Arms") {
                    MeasurementRow(title: "Left Bicep", value: measurement.leftBicepCircumference)
                    MeasurementRow(title: "Right Bicep", value: measurement.rightBicepCircumference)
                    MeasurementRow(title: "Left Forearm", value: measurement.leftForearmCircumference)
                    MeasurementRow(title: "Right Forearm", value: measurement.rightForearmCircumference)
                }
                
                Section("Legs") {
                    MeasurementRow(title: "Left Thigh", value: measurement.leftThighCircumference)
                    MeasurementRow(title: "Right Thigh", value: measurement.rightThighCircumference)
                    MeasurementRow(title: "Left Calf", value: measurement.leftCalfCircumference)
                    MeasurementRow(title: "Right Calf", value: measurement.rightCalfCircumference)
                }
            }
            .navigationTitle("Body Measurements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Share") {
                            isShareSheetPresented = true
                        }
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
            // Present the share sheet when triggered
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: [measurement.summary()])
            }
        }
    }
}
