//
//  ContentView.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//
import SwiftUI
import Foundation
import Vision
import AVFoundation
import UIKit

struct ContentView: View {
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            // Skeleton overlay
            SkeletonView(points: camera.bodyPoints, isTpose: camera.isTpose)
            
            // Capture button
            VStack {
                Spacer()
                if camera.isTpose {
                    Button(action: {
                        camera.captureImage()
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .font(.system(size: 72))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            camera.checkPermission()
        }
        .sheet(isPresented: $camera.showMeasurements) {
            if let measurement = camera.currentMeasurement {
                MeasurementDetailView(measurement: measurement)
            }
        }
        .alert("Error", isPresented: .constant(camera.error != nil)) {
            Button("OK") {
                camera.error = nil
            }
        } message: {
            if let error = camera.error {
                Text(error)
            }
        }
        .overlay {
            if camera.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
            }
        }
    }
}
