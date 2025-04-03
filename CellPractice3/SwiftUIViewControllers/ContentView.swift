import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var camera = CameraModel()
    @State private var showMeasurements = false
    @State private var showInstructions = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let safeAreaBottom = geometry.safeAreaInsets.bottom
                let tabBarHeight: CGFloat = safeAreaBottom + 60
                
                ZStack {
                    // 1. Background and Camera
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    // Camera preview (fills screen except tab bar area)
                    CameraPreview(camera: camera)
                        .frame(height: geometry.size.height - tabBarHeight)
                        .clipped()
                    
                    // 2. Skeleton overlay (matches camera preview exactly)
                    if camera.showOverlay {
                        SkeletonView(points: camera.bodyPoints, isTpose: camera.isTpose)
                            .frame(height: geometry.size.height - tabBarHeight)
                            .allowsHitTesting(false)
                    }
                    
                    // 3. T-Pose text with instruction button
                    VStack(spacing: 0) {
                        if camera.showOverlay {
                            HStack {
                                Text(camera.isTpose ? "Great! Hold the pose" : "Please stand in a T-pose")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                
                                // Instruction Button NEXT TO TEXT
                                Button(action: {
                                    showInstructions = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .imageScale(.large) // Larger icon
                                        .font(.title3) // Adjust size
                                        .frame(width: 35, height: 35) // Bigger button
                                        .foregroundColor(.white) // Ensure visibility
                                }
                                .padding(.leading, 5) // Adds space between text and button
                                .contentShape(Rectangle()) // Ensures it's tappable
                            }
                            .padding(.top, safeAreaBottom > 0 ? safeAreaBottom + 70 : 90) // Moved lower
                        }
                        
                        Spacer()
                        
                        // 4. Camera button at bottom (when in T-pose)
                        if camera.showOverlay && camera.isTpose {
                            Button(action: { camera.captureImage() }) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.black)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding(.bottom, tabBarHeight + 20)
                        }
                    }
                    
                    // 5. Processing overlay (full screen)
                    if camera.isProcessing {
                        Color.black.opacity(0.8)
                            .edgesIgnoringSafeArea(.all)
                            .zIndex(200)
                        
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
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showInstructions) {
            InstructionView(isPresented: $showInstructions)
        }
        .onAppear {
            camera.checkPermission()
            if AppDelegate.isFirstLaunch {
                showInstructions = true
                AppDelegate.isFirstLaunch = false
            }
        }
        .alert("Error", isPresented: .constant(camera.error != nil)) {
            Button("OK") { camera.error = nil }
        } message: {
            if let error = camera.error { Text(error) }
        }
        .onChange(of: camera.showMeasurements) { newValue in
            if newValue { showMeasurements = true }
        }
        .fullScreenCover(isPresented: $showMeasurements) {
            MeasurePreviewViewControllerRepresentable(measurement: camera.currentMeasurement)
                .ignoresSafeArea()
        }
    }
}
