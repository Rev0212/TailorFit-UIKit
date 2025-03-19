//
//  APIEndpoints.swift
//  CellPractice3
//
//  Created by admin29 on 18/03/25.
//

import UIKit


struct APIEndpoints {
    static let baseURL = "https://m2b88tlh-7000.inc1.devtunnels.ms/api"
    static let signup = "\(baseURL)/signup"
}

struct SignupRequest: Codable {
    let name: String
    let email: String
    let mobile: String
}

struct APIResponse: Codable {
    let success: Bool
    let message: String
}

class APIService {
    static let shared = APIService()
    
    func signup(firstName: String, lastName: String, email: String, mobile: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let fullName = "\(firstName) \(lastName)"
        let signupRequest = SignupRequest(name: fullName, email: email, mobile: mobile)
        
        guard let url = URL(string: APIEndpoints.signup),
              let jsonData = try? JSONEncoder().encode(signupRequest) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL or request data"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
