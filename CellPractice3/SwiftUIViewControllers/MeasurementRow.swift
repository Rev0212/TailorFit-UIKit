//
//  MeasurementRow.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//
import SwiftUI
import Foundation
import Vision
import AVFoundation

struct MeasurementRow: View {
    let title: String
    let value: Float?
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let value = value {
                Text(String(format: "%.1f inches", value))
                    .foregroundColor(.secondary)
            } else {
                Text("N/A")
                    .foregroundColor(.secondary)
            }
        }
    }
}
