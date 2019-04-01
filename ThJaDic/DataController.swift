//
//  DataController.swift
//  ThJaDic
//
//  Created by 江藤太一郎 on 2019/02/16.
//  Copyright © 2019 Taichiro Etoh. All rights reserved.
//

//import Foundation
import UIKit
import CoreData

let FETCH_LIMIT = 2000

class ThaiWord: NSManagedObject {
    @NSManaged var spell: String?
    @NSManaged var pronunciation: String?
    @NSManaged var content: String?
}

class DataController: NSObject {
    var persistentContainer: NSPersistentContainer!
    //var persistentStoreDescriptions: NSPersistentStoreDescription!
    var dataList:[String] = []

    init(completionClosure: @escaping () -> ()) {
        super.init()
        
        persistentContainer = NSPersistentContainer(name: "ThJaDic")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
        loadSeedData()

    }
    
    // 初期データ追加
    func loadSeedData() {

        // Create Fetch Request
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ThaiWord")
        //let fetchRequest = NSFetchRequest(entityName: "ThaiWord")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            //try context.fetch(thaiWordFetch) as! [ThaiWord]
        } catch {
            // Error Handling
        }

        if let csvPath = Bundle.main.path(forResource: "thjadic", ofType: "csv") {
            do {
                let csvStr = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                let csvArr = csvStr.components(separatedBy: .newlines)
                for rec in csvArr {
                    let ent:[String] = rec.components(separatedBy: ",")
                    if ent.count == 3 {
                        //print(ent[0])
                        
                        let word = self.createThaiWord()
                        word.spell = ent[0]
                        word.pronunciation = ent[1]
                        word.content = ent[2]
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

        self.saveContext()
        return

        // Documentsディレクトリのパスを取得
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // sqliteファイルが置かれるURL
        let storeUrl = documentsDirectory.appendingPathComponent("ThJaDic.sqlite")
        
        // そのURLにファイルが存在しない(=基本は初期化時)時、
        // 事前に作成したsqliteファイルをそこにコピーする
        if !FileManager.default.fileExists(atPath: (storeUrl.path)) {
            let seededDataUrl = Bundle.main.url(forResource: "ThJaDic", withExtension: "sqlite")
            try! FileManager.default.copyItem(at: seededDataUrl!, to: storeUrl)
        }
        
        // 各種設定
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        
        persistentContainer.persistentStoreDescriptions = [description]
        //persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
        //    if let error = error as NSError? {
        //        fatalError("Failed to load Core Data stack: \(error)")
        //    }
        //    completionClosure()
        //})
    }

    func createThaiWord() -> ThaiWord {
        let context = persistentContainer.viewContext
        let thaiWord = NSEntityDescription.insertNewObject(forEntityName: "ThaiWord", into: context) as! ThaiWord
        return thaiWord
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchThaiWord(searchText: String) -> [ThaiWord] {
        let context = persistentContainer.viewContext
        let thaiWordFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ThaiWord")

        // 検索条件追加
        thaiWordFetch.predicate = NSPredicate(format: "spell BEGINSWITH[c] %@ OR pronunciation BEGINSWITH[c] %@", searchText, searchText)

        // フェッチ件数制限する
        thaiWordFetch.fetchLimit = FETCH_LIMIT

        // 並び順指定
        thaiWordFetch.sortDescriptors = [NSSortDescriptor(key: "spell", ascending: false)]

        do {
            let thaiWordFetch = try context.fetch(thaiWordFetch) as! [ThaiWord]
            return thaiWordFetch
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return []
    }

}
