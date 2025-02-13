//
//  Models.swift
//  CellPractice3
//
//  Created by admin29 on 15/11/24.
//

import Foundation

struct UserMeasurements: Decodable{
    var details: UserDetails
    var size: ClothingSize
    var measurements: BodyMeasurement
}

struct UserDetails: Codable {
    var name: String
    var age: String
    var info: String
}

struct ClothingSize: Codable {
    var shirt: String
    var pant: String
}

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
    
    enum CodingKeys: String, CodingKey {
        case id
        case processedImage = "processed_image"
        case shoulderWidth = "shoulder_width"
        case chestCircumference = "chest_circumference"
        case waistCircumference = "waist_circumference"
        case hipCircumference = "hip_circumference"
        case leftBicepCircumference = "left_bicep_circumference"
        case rightBicepCircumference = "right_bicep_circumference"
        case leftForearmCircumference = "left_forearm_circumference"
        case rightForearmCircumference = "right_forearm_circumference"
        case leftThighCircumference = "left_thigh_circumference"
        case rightThighCircumference = "right_thigh_circumference"
        case leftCalfCircumference = "left_calf_circumference"
        case rightCalfCircumference = "right_calf_circumference"
        case createdAt = "created_at"
    }
}

struct SavedData: Codable {
    var detailsValues: [String: String]
    var sizeValues: [String: String]
    var measurementValues: [String: String]
}

extension BodyMeasurement {
    func summary() -> String {
        var summaryText = "Body Measurements:\n"
        if let shoulderWidth = shoulderWidth {
            summaryText += "Shoulder Width: \(String(format: "%.1f", shoulderWidth)) inches\n"
        }
        if let chestCircumference = chestCircumference {
            summaryText += "Chest Circumference: \(String(format: "%.1f", chestCircumference)) inches\n"
        }
        if let waistCircumference = waistCircumference {
            summaryText += "Waist Circumference: \(String(format: "%.1f", waistCircumference)) inches\n"
        }
        if let hipCircumference = hipCircumference {
            summaryText += "Hip Circumference: \(String(format: "%.1f", hipCircumference)) inches\n"
        }
        
        if let leftBicepCircumference = leftBicepCircumference {
            summaryText += "Bicep Circumference: \(String(format: "%.1f", leftBicepCircumference)) inches\n"
        }
        if let rightBicepCircumference = rightBicepCircumference {
            summaryText += "Bicep Circumference: \(String(format: "%.1f", rightBicepCircumference)) inches\n"
        }
        if let leftForearmCircumference = leftForearmCircumference {
            summaryText += "Forearm Circumference: \(String(format: "%.1f", leftForearmCircumference)) inches\n"
        }
        if let rightForearmCircumference = rightForearmCircumference {
            summaryText += "Forearm Circumference: \(String(format: "%.1f", rightForearmCircumference)) inches\n"
        }
        if let leftThighCircumference = leftThighCircumference {
            summaryText += "Thigh Circumference: \(String(format: "%.1f", leftThighCircumference)) inches\n"
        }
        if let rightThighCircumference = rightThighCircumference {
            summaryText += "Thigh Circumference: \(String(format: "%.1f", rightThighCircumference)) inches\n"
        }
        if let leftCalfCircumference = leftCalfCircumference {
            summaryText += "Calf Circumference: \(String(format: "%.1f", leftCalfCircumference)) inches\n"
        }
        if let rightCalfCircumference = rightCalfCircumference {
            summaryText += "Calf Circumference: \(String(format: "%.1f", rightCalfCircumference)) inches\n"
        }
        summaryText += "\n"
        return summaryText
    }
}

struct TryOnResponse: Codable {
    let id: Int
    let personImage: String
    let garmentImage: String
    let garmentDescription: String
    let resultImage: String
    let maskImage: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case personImage = "person_image"
        case garmentImage = "garment_image"
        case garmentDescription = "garment_description"
        case resultImage = "result_image"
        case maskImage = "mask_image"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case errorMessage = "error_message"
    }
}
