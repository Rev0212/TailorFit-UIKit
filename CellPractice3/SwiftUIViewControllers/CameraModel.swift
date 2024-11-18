import SwiftUI
import Foundation
import Vision
import AVFoundation

// Define the delegate protocol
protocol CameraModelDelegate {
    func navigateToMeasurePreview(measurement: BodyMeasurement)
}

class CameraModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var bodyPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    @Published var permissionGranted = false
    @Published var isTpose: Bool = false
    @Published var capturedImage: UIImage?
    @Published var currentMeasurement: BodyMeasurement?
    @Published var isLoading = false
    @Published var showMeasurements = false
    @Published var error: String?
    
    private let videoOutput = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "camera.queue")
    var delegate: CameraModelDelegate?
    
    override init() {
        super.init()
    }
    
    // Check for camera permission
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }
    
    // Set up the camera session
    private func setupCamera() {
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(self, queue: queue)
                
                if let connection = videoOutput.connection(with: .video) {
                    connection.videoOrientation = .portrait
                }
            }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.session.startRunning()
            }
            
            permissionGranted = true
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    // Capture the image and trigger the upload
    func captureImage() {
        guard let connection = videoOutput.connection(with: .video) else { return }
        
        videoOutput.setSampleBufferDelegate(nil, queue: nil)
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        connection.videoOrientation = .portrait
        
        self.isLoading = true
    }
    
    // Convert sample buffer to UIImage
    private func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    // Stop the camera session
    func stopCamera() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    // Upload the measurement data and notify the delegate
    func uploadMeasurement() {
        guard let image = capturedImage else { return }

        Task {
            do {
                let measurement = try await APIClient.shared.uploadMeasurement(image: image)
                DispatchQueue.main.async {
                    self.currentMeasurement = measurement
                    self.showMeasurements = true
                    self.stopCamera()
                    
                    // Notify the delegate to navigate
                    self.delegate?.navigateToMeasurePreview(measurement: measurement)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    // Check if the user is in T-pose
    private func checkTpose(points: [VNHumanBodyPoseObservation.JointName: CGPoint]) {
        guard let leftShoulder = points[.leftShoulder],
              let leftElbow = points[.leftElbow],
              let leftWrist = points[.leftWrist],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist] else { return }
        
        let leftArmDeltaY = abs(leftWrist.y - leftShoulder.y)
        let rightArmDeltaY = abs(rightWrist.y - rightShoulder.y)
        
        let leftArmLength = distance(from: leftShoulder, to: leftWrist)
        let rightArmLength = distance(from: rightShoulder, to: rightWrist)
        
        let isArmsHorizontal = leftArmDeltaY < 0.15 && rightArmDeltaY < 0.15
        let isArmsExtended = leftArmLength > 0.2 && rightArmLength > 0.2
        
        DispatchQueue.main.async {
            withAnimation {
                self.isTpose = isArmsHorizontal && isArmsExtended
            }
        }
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Sample buffer delegate method to process video frames
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard let observation = request.results?.first as? VNHumanBodyPoseObservation else { return }
            
            let points = try? observation.recognizedPoints(.all)
            DispatchQueue.main.async {
                self?.processBodyPoints(points)
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        if isLoading, let image = imageFromSampleBuffer(sampleBuffer) {
            DispatchQueue.main.async {
                self.capturedImage = image
                self.uploadMeasurement()
                self.isLoading = false
            }
        }
    }
    
    private func processBodyPoints(_ points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]?) {
        guard let points = points else { return }
        
        var convertedPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
        
        for (joint, point) in points {
            let cgPoint = CGPoint(
                x: point.location.x,
                y: 1 - point.location.y  // Flip Y coordinate
            )
            convertedPoints[joint] = cgPoint
        }
        
        DispatchQueue.main.async {
            self.bodyPoints = convertedPoints
            self.checkTpose(points: convertedPoints)
        }
    }
}
