import UIKit
import AVFoundation
import Vision

class MeasureCameraViewController: UIViewController{

    // Models
    struct BodyMeasurement: Codable {
        let id: Int
        let processedImage: String?
        let shoulderWidth: Float?
        let chestCircumference: Float?
        let waistCircumference: Float?
        let hipCircumference: Float?
        let leftBicepCircumference: Float?
        let rightBicepCircumference: Float?
        let leftForearmCircumference: Float?
        let rightForearmCircumference: Float?
        let leftThighCircumference: Float?
        let rightThighCircumference: Float?
        let leftCalfCircumference: Float?
        let rightCalfCircumference: Float?
        let createdAt: String
    }
    
    // Properties
    private let videoOutput = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "camera.queue")
    private var currentMeasurement: BodyMeasurement?
    private var capturedImage: UIImage?
    private var bodyPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    private var isTpose: Bool = false
    private var isLoading: Bool = false
    private var showMeasurements: Bool = false
    private var error: String?
    
    // UI Elements
    private let cameraPreviewView = UIView()
    private let captureButton = UIButton()
    private let skeletonView = UIView()
    private let loadingView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPreview()
        setupCaptureButton()
        setupSkeletonView()
        setupLoadingView()
        checkPermission()
    }
    
    private func setupCameraPreview() {
        view.addSubview(cameraPreviewView)
        cameraPreviewView.frame = view.bounds
        cameraPreviewView.backgroundColor = .black
    }
    
    private func setupCaptureButton() {
        view.addSubview(captureButton)
        captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        captureButton.tintColor = .white
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupSkeletonView() {
        view.addSubview(skeletonView)
        skeletonView.frame = view.bounds
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.style = .large
        loadingView.color = .white
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkPermission() {
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
    
    private func setupCamera() {
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            
            let session = AVCaptureSession()
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
                session.startRunning()
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = cameraPreviewView.bounds
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            cameraPreviewView.layer.addSublayer(previewLayer)
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    @objc private func captureImage() {
        guard let connection = videoOutput.connection(with: .video) else { return }
        
        videoOutput.setSampleBufferDelegate(nil, queue: nil)
        
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        connection.videoOrientation = .portrait
        
        isLoading = true
    }
    
    private func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func uploadMeasurement() {
        guard let image = capturedImage else { return }
        
        Task {
            do {
                let measurement = try await APIClient.shared.uploadMeasurement(image: image)
                DispatchQueue.main.async {
                    self.currentMeasurement = measurement
                    self.showMeasurements = true
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func processBodyPoints(_ points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]?) {
        guard let points = points else { return }
        
        var convertedPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
        
        // Convert Vision coordinates to UIKit coordinates
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
    
    private func checkTpose(points: [VNHumanBodyPoseObservation.JointName: CGPoint]) {
        guard let leftShoulder = points[.leftShoulder],
              let leftElbow = points[.leftElbow],
              let leftWrist = points[.leftWrist],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist] else { return }
        
        // Calculate angles for arms relative to horizontal
        let leftArmDeltaY = abs(leftWrist.y - leftShoulder.y)
        let rightArmDeltaY = abs(rightWrist.y - rightShoulder.y)
        
        // Check if arms are roughly horizontal and extended
        let leftArmLength = distance(from: leftShoulder, to: leftWrist)
        let rightArmLength = distance(from: rightShoulder, to: rightWrist)
        
        let isArmsHorizontal = leftArmDeltaY < 0.15 && rightArmDeltaY < 0.15
        let isArmsExtended = leftArmLength > 0.2 && rightArmLength > 0.2
        
        DispatchQueue.main.async {
            self.isTpose = isArmsHorizontal && isArmsExtended
        }
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}

extension MeasureCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
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
            }
        }
    }
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://10.223.247.196:8000/api"
    
    func uploadMeasurement(image: UIImage) async throws -> MeasureCameraViewController.BodyMeasurement {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "com.yourapp.error", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unable to process image"])
        }
        
        let url = URL(string: "\(baseURL)/measurements/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let fileName = "image.jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        // Use the full namespace here: MeasureCameraViewController.BodyMeasurement
        let measurement = try decoder.decode(MeasureCameraViewController.BodyMeasurement.self, from: data)
        
        return measurement
    }
}

