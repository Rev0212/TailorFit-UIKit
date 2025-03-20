//
//  SavedTryOn.swift
//  CellPractice3
//
//  Created by admin29 on 11/03/25.
//


import SwiftData
import UIKit

@Model
class SavedTryOn {
    var photoImageData: Data
    var apparelImageData: Data
    var resultImageData: Data
    var timestamp: Date

    init(mainImageData: Data, apparelImageData: Data, resultImageData: Data, timestamp: Date) {
        self.photoImageData = mainImageData
        self.apparelImageData = apparelImageData
        self.resultImageData = resultImageData
        self.timestamp = timestamp
    }
}
