//
//  Photos+CoreDataProperties.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2021-12-24.
//  Copyright © 2021 MI Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var desc: String?
    @NSManaged public var upload: String?

}
