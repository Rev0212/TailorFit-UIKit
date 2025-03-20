import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @StateObject private var camera = CameraModel()
    @State private var showMeasurements = false // State to control navigation

    var body: some View {
        ZStack {
            // Camera preview (always visible)
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            // Show skeleton, text, and button only if overlay is visible
            if camera.showOverlay {
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
            
            // Show activity indicator when processing
            if camera.isProcessing {
                Color.black.opacity(0.8) // Dark overlay
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.0)
                    
                    Text("Processing...")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.top, 30)
                }
            }
        }
        .disabled(camera.isProcessing)
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
