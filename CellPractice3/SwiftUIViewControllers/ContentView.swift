



import SwiftUI
import AVFoundation
import Foundation


struct ContentView: View {
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        NavigationStack {
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
            
            // Navigation to MeasurePreviewViewController when measurement is available
            NavigationLink(
                destination: MeasurePreviewViewControllerRepresentable(measurement: camera.currentMeasurement),
                isActive: $camera.showMeasurements
            ) {
                EmptyView()
            }
            .hidden() // Hide the link, but allow navigation when active
        }
    }
}
