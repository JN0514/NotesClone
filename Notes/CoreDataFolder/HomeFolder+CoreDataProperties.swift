//
//  HomeFolder+CoreDataProperties.swift
//  
//
//  Created by Jayasurya on 23/04/23.
//
//

import Foundation
import CoreData


extension HomeFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeFolder> {
        return NSFetchRequest<HomeFolder>(entityName: "HomeFolder")
    }

    @NSManaged public var folderName: String
    @NSManaged public var folderType: String

}
