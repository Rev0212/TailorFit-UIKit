//
//  ProfileService.swift
//  CellPractice3
//
//  Created by admin29 on 11/03/25.
//
import SwiftUI

class ProfileService {
    static let shared = ProfileService()

    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        // Simulate an API call
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let profile = Profile(name: "Hariharan", image: UIImage(systemName: "person.circle.fill"))
            completion(.success(profile))
        }
    }
}

struct Profile {
    let name: String
    let image: UIImage?
}
