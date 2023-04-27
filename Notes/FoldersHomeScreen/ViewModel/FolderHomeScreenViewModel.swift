//
//  FolderHomeScreenViewModel.swift
//  Notes
//
//  Created by Jayasurya on 15/04/23.
//

import Foundation
import UIKit
import Combine

struct FolderHomeScreenViewModel{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var folderNames: [HomeFolder] = []
    var backUpFolderNames:[HomeFolder] = []

    
    var tags = [Tag]()
    var backUpTags = [Tag]()

    mutating func getFolderNames(){
        do{
            backUpFolderNames = try context.fetch(HomeFolder.fetchRequest())
            folderNames = backUpFolderNames
        }
        catch(let error as NSError){
            fatalError(error.localizedDescription)
        }
    }
    
    mutating func createFolderNames(name: String, type: FolderType){
        let newFolder = HomeFolder(context: context)
        newFolder.folderName = name
        newFolder.typeEnum = type
        
        saveContext()
        getFolderNames()
    }
    
    mutating func updateFolderNames(folder: HomeFolder, newName: String){
        folder.folderName = newName
        saveContext()
        getFolderNames()
    }
    
    mutating func deleteFolderNames(folder: HomeFolder, newName: String){
        context.delete(folder)
        saveContext()
        getFolderNames()
    }
    
    func saveContext(){
        do{
            try context.save()
        }
        catch(let err as NSError){
            fatalError(err.localizedDescription)
        }
    }

}


extension HomeFolder{
    var typeEnum: FolderType{
        get{
            return FolderType(rawValue: self.folderType)!
        }
        set{
            self.folderType = newValue.rawValue
        }
    }
}
