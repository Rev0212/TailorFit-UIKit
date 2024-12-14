struct UserProfile: Codable {
    let id: UUID
    let name: String
    let appleID: String
    let phoneNumber: String
    var familyMembers: [FamilyMember] = []
}
