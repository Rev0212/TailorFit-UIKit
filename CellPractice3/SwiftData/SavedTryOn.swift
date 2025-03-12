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
    var imageData: Data
    var timestamp: Date

    init(imageData: Data, timestamp: Date) {
        self.imageData = imageData
        self.timestamp = timestamp
    }
}
