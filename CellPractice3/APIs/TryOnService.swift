//
//  TryOnService.swift
//  CellPractice3
//
//  Created by admin29 on 18/11/24.
//
import UIKit
import Foundation

class TryOnService {
    private let baseURL = "https://m2b88tlh-8000.inc1.devtunnels.ms"
    private let apiEndpoint = "/api/tryon/try_on/"
    
    func performTryOn(personImage: UIImage, garmentImage: UIImage, garmentDescription: String, completion: @escaping (Result<TryOnResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + apiEndpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        // Convert images to Data
        guard let personImageData = personImage.jpegData(compressionQuality: 0.8),
              let garmentImageData = garmentImage.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image conversion failed", code: -2)))
            return
        }
        
        // Create multipart form data request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add person image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"person_image\"; filename=\"person.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(personImageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add garment image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"garment_image\"; filename=\"garment.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(garmentImageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add garment description
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"garment_description\"\r\n\r\n".data(using: .utf8)!)
        body.append(garmentDescription.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -3)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TryOnResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchResultImage(from urlPath: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: baseURL + urlPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "Invalid image data", code: -2)))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
}
