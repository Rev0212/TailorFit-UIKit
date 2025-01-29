
import Foundation



struct Measurement: Codable {
    let id: UUID
    let familyMemberID: UUID? // Optional for parent users
    let userProfileID: UUID? // Optional for parent users
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
    let createdAt: Date
}
