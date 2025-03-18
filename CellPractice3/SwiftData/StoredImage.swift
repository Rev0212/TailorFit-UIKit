//
//  StoredImage.swift
//  CellPractice3
//
//  Created by admin29 on 18/03/25.
//


import SwiftData
import UIKit

@Model
final class StoredImage {
    var imageData: Data
    var type: ImageType
    var createdAt: Date
    var isSample: Bool
    
    enum ImageType: String, Codable {
        case photo
        case apparel
    }
    
    init(imageData: Data, type: ImageType, isSample: Bool = false) {
        self.imageData = imageData
        self.type = type
        self.createdAt = Date()
        self.isSample = isSample
    }
}
