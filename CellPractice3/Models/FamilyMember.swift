struct FamilyMember: Codable {
    let id: UUID
    let userProfileID: UUID
    let name: String
    let age: Int
    let pantSize: String
    let shirtSize: String
    var measurements: [Measurement] = []
    var tryOns: [TryOn] = []
}
