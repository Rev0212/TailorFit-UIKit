//
//  SavedImages.swift
//  CellPractice3
//
//  Created by admin29 on 07/03/25.
//

import SwiftData
import UIKit

@Model
class SavedImages {
    var photoImageData: Data? // Stores the selected photo image
    var apparelImageData: Data? // Stores the selected apparel image

    init(photoImage: UIImage?, apparelImage: UIImage?) {
        self.photoImageData = photoImage?.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
        self.apparelImageData = apparelImage?.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
    }

    // Convert Data back to UIImage for display
    var photoImage: UIImage? {
        guard let photoImageData = photoImageData else { return nil }
        return UIImage(data: photoImageData)
    }

    var apparelImage: UIImage? {
        guard let apparelImageData = apparelImageData else { return nil }
        return UIImage(data: apparelImageData)
    }

    // MARK: - Provide Initial Images
    static func initialImages() -> [SavedImages] {
        return [
            SavedImages(photoImage: UIImage(named: "person1"), apparelImage: UIImage(named: "dress1")),
            SavedImages(photoImage: UIImage(named: "person2"), apparelImage: UIImage(named: "dress2")),
            SavedImages(photoImage: nil, apparelImage: UIImage(named: "dress3")), // No person image, only dress
            SavedImages(photoImage: nil, apparelImage: UIImage(named: "dress4"))  // No person image, only dress
        ]
    }
}
