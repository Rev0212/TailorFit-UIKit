//
//  CameraViewController.swift
//  CellPractice3
//
//  Created by admin29 on 02/11/24.
//

import UIKit
import AVFoundation
import CoreML

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraButton()
    }
    
    private func setupCameraButton() {
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        checkCameraPermission()
    }
    


    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.presentCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.presentCamera()
                    }
                }
            }
            
        case .denied:
            presentCameraSettings()
            
        case .restricted:
            // Handle restricted state (e.g., parental controls)
            showAlert(title: "Camera Restricted",
                     message: "Camera access is restricted. Please check your device settings.")
            
        @unknown default:
            break
        }
    }
    
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func presentCameraSettings() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please enable camera access in Settings to use this feature.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            // Handle the captured/edited image
            handleCapturedImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func handleCapturedImage(_ image: UIImage) {
        // Preprocess the image for ML Model (resize, normalize, etc.)
        guard let resizedImage = image.resize(to: CGSize(width: 224, height: 224)) else {
            showAlert(title: "Error", message: "Image resizing failed")
            return
        }
        
        // Convert the image to a format suitable for Core ML (e.g., CVPixelBuffer)
        guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            showAlert(title: "Error", message: "Image conversion failed")
            return
        }
        
        // Send the image to the ML model
//        sendToMLModel(pixelBuffer)
    }
    
//    private func sendToMLModel(_ pixelBuffer: CVPixelBuffer) {
//        // Assuming your model is named 'YourModel' and it is already integrated with CoreML
//        do {
//            let model = try YourModel(configuration: MLModelConfiguration())
//            let prediction = try model.prediction(input: YourModelInput(image: pixelBuffer))
//
//            // Process the model's prediction
//            handleModelPrediction(prediction)
//
//        } catch {
//            showAlert(title: "Model Error", message: "Failed to make prediction: \(error.localizedDescription)")
//        }
//    }
    
//    private func handleModelPrediction(_ prediction: YourModelOutput) {
//        // Use the prediction results (e.g., display it on the UI, log it, etc.)
//        print("Prediction result: \(prediction)")
//    }
}



// MARK: - Image Preprocessing Extensions
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        guard let cgImage = self.cgImage else { return nil }
        
        let options: [CFString: Any] = [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true]
        
        var pixelBuffer: CVPixelBuffer?
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, options as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
    
  
}

