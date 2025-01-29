import Foundation

struct UserProfile: Codable {
    let id: UUID
    let name: String
    let appleID: String
    let dob: Date
    let phoneNumber: String
    let country: String
    var familyMembers: [FamilyMember] = []
}
