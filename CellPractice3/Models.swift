//
//  Models.swift
//  CellPractice3
//
//  Created by admin29 on 15/11/24.
//

import Foundation

struct UserMeasurements: Codable {
    var details: UserDetails
    var size: ClothingSize
    var measurements: BodyMeasurements
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

struct BodyMeasurements: Codable {
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
