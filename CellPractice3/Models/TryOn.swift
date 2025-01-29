

import Foundation

struct TryOn: Codable {
    let id: UUID
    let familyMemberID: UUID? // Optional for family members
    let userProfileID: UUID? // Optional for parent users
    let originalImage: String
    let clothImage: String
    let resultImage: String
}
