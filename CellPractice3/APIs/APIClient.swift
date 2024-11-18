//
//  APIClient.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//
import SwiftUI
import Foundation
import UIKit

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://10.223.255.223:8000/api"
    
    func uploadMeasurement(image: UIImage) async throws -> BodyMeasurement {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "\(baseURL)/measurements/")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"measurement.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print(data)
        print(try JSONDecoder().decode(BodyMeasurement.self, from: data))
        return try JSONDecoder().decode(BodyMeasurement.self, from: data)
    }
}
