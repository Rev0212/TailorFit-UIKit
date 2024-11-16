//import UIKit
//import AVFoundation
//import Vision
//
//import UIKit
//import AVFoundation
//import Vision
//
//// MARK: - Models
////struct BodyMeasurement: Codable {
////    let id: Int
////    let processedImage: String?
////    let shoulderWidth: Float?
////    let chestCircumference: Float?
////    let waistCircumference: Float?
////    let hipCircumference: Float?
////    let leftBicepCircumference: Float?
////    let rightBicepCircumference: Float?
////    let leftForearmCircumference: Float?
////    let rightForearmCircumference: Float?
////    let leftThighCircumference: Float?
////    let rightThighCircumference: Float?
////    let leftCalfCircumference: Float?
////    let rightCalfCircumference: Float?
////    let createdAt: String
////}
//
//// MARK: - MeasureCameraViewController
//final class MeasureCameraViewController: UIViewController {
//    
//    // MARK: - Properties
//    private let captureSession = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private let processingQueue = DispatchQueue(label: "camera.processing.queue")
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    private var state = State() {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    // MARK: - UI Elements
//    @IBOutlet private weak var cameraPreviewView: UIView!
//    @IBOutlet private weak var skeletonView: UIView!
//    @IBOutlet private weak var captureButton: UIButton!
//    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        checkCameraPermission()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        previewLayer?.frame = cameraPreviewView.bounds
//    }
//}
//
//// MARK: - UI Setup
//private extension MeasureCameraViewController {
//    func setupUI() {
//        configureCameraPreview()
//        configureCaptureButton()
//        configureSkeletonView()
//        configureLoadingView()
//    }
//    
//    func configureCameraPreview() {
//        cameraPreviewView.backgroundColor = .black
//    }
//    
//    
//    
//    func configureSkeletonView() {
//        skeletonView.backgroundColor = .clear
//    }
//    
//    func configureLoadingView() {
//        loadingView.style = .large
//        loadingView.color = .white
//        loadingView.hidesWhenStopped = true
//    }
//    
//    func updateUI() {
//        DispatchQueue.main.async { [weak self] in
//            self?.loadingView.isHidden = !(self?.state.isLoading)! ?? false
//            if self?.state.isLoading == true {
//                self?.loadingView.startAnimating()
//            } else {
//                self?.loadingView.stopAnimating()
//            }
//            // Update other UI elements based on state
//        }
//    }
//}
//
//// MARK: - Camera Setup
//private extension MeasureCameraViewController {
//    func checkCameraPermission() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            setupCamera()
//        case .notDetermined:
//            requestCameraPermission()
//        default:
//            // Handle denied/restricted states
//            break
//        }
//    }
//    
//    func requestCameraPermission() {
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//            if granted {
//                DispatchQueue.main.async {
//                    self?.setupCamera()
//                }
//            }
//        }
//    }
//    
//    func setupCamera() {
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        configureCaptureSession(with: input)
//        configurePreviewLayer()
//        startCaptureSession()
//    }
//    
//    func configureCaptureSession(with input: AVCaptureDeviceInput) {
//        guard captureSession.canAddInput(input) else { return }
//        captureSession.addInput(input)
//        
//        guard captureSession.canAddOutput(videoOutput) else { return }
//        captureSession.addOutput(videoOutput)
//        
//        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)
//        
//        if let connection = videoOutput.connection(with: .video) {
//            connection.videoOrientation = .portrait
//        }
//    }
//    
//    func configurePreviewLayer() {
//        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
//        layer.videoGravity = .resizeAspectFill
//        layer.connection?.videoOrientation = .portrait
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.cameraPreviewView.layer.addSublayer(layer)
//            layer.frame = self?.cameraPreviewView.bounds ?? .zero
//            self?.previewLayer = layer
//        }
//    }
//    
//    func startCaptureSession() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self?.captureSession.startRunning()
//        }
//    }
//}
//
//// MARK: - Actions
//private extension MeasureCameraViewController {
//    @objc func captureButtonTapped() {
//        guard let connection = videoOutput.connection(with: .video) else { return }
//        connection.videoOrientation = .portrait
//        
//        state.isLoading = true
//    }
//}
//
//// MARK: - Image Processing
//private extension MeasureCameraViewController {
//    func processImage(_ sampleBuffer: CMSampleBuffer) {
//        guard let image = imageFromSampleBuffer(sampleBuffer) else { return }
//        state.capturedImage = image
//        
//        Task {
//            await uploadMeasurement(image: image)
//        }
//    }
//    
//    func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
//        
//        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//        let context = CIContext()
//        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
//        
//        return UIImage(cgImage: cgImage)
//    }
//}
//
//// MARK: - Body Pose Detection
//private extension MeasureCameraViewController {
//    func detectBodyPose(in pixelBuffer: CVPixelBuffer) {
//        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
//            guard let observation = request.results?.first as? VNHumanBodyPoseObservation else { return }
//            
//            if let points = try? observation.recognizedPoints(.all) {
//                self?.processBodyPoints(points)
//            }
//        }
//        
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
//    
//    func processBodyPoints(_ points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
//        let convertedPoints = points.mapValues { point in
//            CGPoint(x: point.location.x, y: 1 - point.location.y)
//        }
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.state.bodyPoints = convertedPoints
//            self?.checkTpose(points: convertedPoints)
//        }
//    }
//    
//    func checkTpose(points: [VNHumanBodyPoseObservation.JointName: CGPoint]) {
//        guard let leftShoulder = points[.leftShoulder],
//              let leftWrist = points[.leftWrist],
//              let rightShoulder = points[.rightShoulder],
//              let rightWrist = points[.rightWrist] else { return }
//        
//        let leftArmDeltaY = abs(leftWrist.y - leftShoulder.y)
//        let rightArmDeltaY = abs(rightWrist.y - rightShoulder.y)
//        
//        let leftArmLength = distance(from: leftShoulder, to: leftWrist)
//        let rightArmLength = distance(from: rightShoulder, to: rightWrist)
//        
//        let isArmsHorizontal = leftArmDeltaY < 0.15 && rightArmDeltaY < 0.15
//        let isArmsExtended = leftArmLength > 0.2 && rightArmLength > 0.2
//        
//        state.isTpose = isArmsHorizontal && isArmsExtended
//    }
//    
//    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
//        let deltaX = point2.x - point1.x
//        let deltaY = point2.y - point1.y
//        return sqrt(deltaX * deltaX + deltaY * deltaY)
//    }
//}
//
//// MARK: - Networking
//private extension MeasureCameraViewController {
//    func uploadMeasurement(image: UIImage) async {
//        do {
//            let measurement = try await APIClient.shared.uploadMeasurement(image: image)
//            DispatchQueue.main.async { [weak self] in
//                self?.state.currentMeasurement = measurement
//                self?.state.showMeasurements = true
//                self?.state.isLoading = false
//            }
//        } catch {
//            DispatchQueue.main.async { [weak self] in
//                self?.state.error = error.localizedDescription
//                self?.state.isLoading = false
//            }
//        }
//    }
//}
//
//// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
//extension MeasureCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        
//        detectBodyPose(in: pixelBuffer)
//        
//        if state.isLoading {
//            processImage(sampleBuffer)
//        }
//    }
//}
//
//// MARK: - State
//private extension MeasureCameraViewController {
//    struct State {
//        var currentMeasurement: BodyMeasurement?
//        var capturedImage: UIImage?
//        var bodyPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
//        var isTpose = false
//        var isLoading = false
//        var showMeasurements = false
//        var error: String?
//    }
//}
//
//// MARK: - APIClient
//final class APIClient {
//    static let shared = APIClient()
//    private let baseURL = "http://10.223.247.196:8000/api"
//    
//    private init() {}
//    
//    func uploadMeasurement(image: UIImage) async throws -> BodyMeasurement {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            throw APIError.imageProcessingFailed
//        }
//        
//        let url = URL(string: "\(baseURL)/measurements/")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let body = createMultipartBody(with: imageData, boundary: boundary)
//        request.httpBody = body
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//        return try JSONDecoder().decode(BodyMeasurement.self, from: data)
//    }
//    
//    private func createMultipartBody(with imageData: Data, boundary: String) -> Data {
//        var body = Data()
//        let filename = "image.jpg"
//        
//        // Add image data
//        body.append("--\(boundary)\r\n")
//        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
//        body.append("Content-Type: image/jpeg\r\n\r\n")
//        body.append(imageData)
//        body.append("\r\n")
//        
//        // Add closing boundary
//        body.append("--\(boundary)--\r\n")
//        
//        return body
//    }
//    
//    enum APIError: Error {
//        case imageProcessingFailed
//    }
//}
//
//// MARK: - Data Extension
//private extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}
//
//private extension MeasureCameraViewController {
//    func configureCaptureButton() {
//        // Remove existing system image configuration
//        captureButton.setImage(nil, for: .normal)
//        
//        // Set up basic button properties
//        captureButton.backgroundColor = .clear
//        captureButton.layer.masksToBounds = true
//        captureButton.layer.cornerRadius = 40  // Adjust corner radius to match the button's circular shape
//        
//        // Set button frame
//        captureButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)  // Adjust button size to make it more prominent
//        
//        // Create inner circle (white fill)
//        let innerCircle = CALayer()
//        innerCircle.frame = CGRect(x: 14, y: 14, width: 72, height: 72)  // Position the circle inside the button
//        innerCircle.cornerRadius = 36
//        innerCircle.backgroundColor = UIColor.white.cgColor
//        
//        // Create outer ring
//        let outerRing = CALayer()
//        outerRing.frame = CGRect(x: 0, y: 0, width: 100, height: 100)  // Outer ring size matches button size
//        outerRing.cornerRadius = 50  // Match the corner radius with the button's circular shape
//        outerRing.borderWidth = 6
//        outerRing.borderColor = UIColor.white.cgColor
//        outerRing.shadowColor = UIColor.black.cgColor  // Add shadow for depth
//        outerRing.shadowOpacity = 0.4
//        outerRing.shadowOffset = CGSize(width: 2, height: 2)
//        outerRing.shadowRadius = 4
//        
//        // Add layers to button
//        captureButton.layer.addSublayer(outerRing)
//        captureButton.layer.addSublayer(innerCircle)
//        
//        // Add tap handler
//        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
//        
//        // Add tap animation
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCaptureButtonTap))
//        captureButton.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc private func handleCaptureButtonTap() {
//        // Animate button tap
//        UIView.animate(withDuration: 0.1, animations: {
//            self.captureButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }) { _ in
//            UIView.animate(withDuration: 0.1) {
//                self.captureButton.transform = .identity
//            }
//        }
//    }
//}
//
