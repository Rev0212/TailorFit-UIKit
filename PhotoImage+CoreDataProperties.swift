//
//  PhotoImage+CoreDataProperties.swift
//  CellPractice3
//
//  Created by admin29 on 07/03/25.
//
//

import Foundation
import CoreData


extension PhotoImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoImage> {
        return NSFetchRequest<PhotoImage>(entityName: "PhotoImage")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?

}

extension PhotoImage : Identifiable {

}
