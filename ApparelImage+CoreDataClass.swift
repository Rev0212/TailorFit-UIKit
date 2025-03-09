//
//  ApparelImage+CoreDataClass.swift
//  CellPractice3
//
//  Created by admin29 on 07/03/25.
//
//

import Foundation
import CoreData

@objc(ApparelImage)
public class ApparelImage: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
}

extension ApparelImage {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApparelImage> {
        return NSFetchRequest<ApparelImage>(entityName: "ApparelImage")
    }
}
