import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @StateObject private var camera = CameraModel()
    @State private var showMeasurements = false // State to control navigation

    var body: some View {
        ZStack {
            // Camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            // Skeleton overlay
            SkeletonView(points: camera.bodyPoints, isTpose: camera.isTpose)
            
            // Text overlay to guide the user
            VStack {
                Text(camera.isTpose ? "Great! Hold the pose and tap the camera button." : "Please stand in a T-pose.")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 50)
                
                Spacer()
                
                // Capture button
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
        .onChange(of: camera.showMeasurements) { newValue in
            // Trigger navigation when showMeasurements changes
            if newValue {
                showMeasurements = true
            }
        }
        .fullScreenCover(isPresented: $showMeasurements) {
            // Present the MeasurePreviewViewControllerRepresentable
            MeasurePreviewViewControllerRepresentable(measurement: camera.currentMeasurement)
                .ignoresSafeArea()
        }
    }
}
