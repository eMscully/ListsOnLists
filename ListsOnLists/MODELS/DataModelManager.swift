
import Foundation
import UIKit
import CoreData

class DataModelManager {
    static let shared = DataModelManager()
    
   // var items = [ListItem]()
  //  var categories = [Category]()
  //  var entity: [NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    init(){}
}
  
 //   func saveData() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//        //note to self: you can't call for a table view to reload its data due to this core data method now living within a singleton. make sure to adjust code and manually call for table view to reload when needed
//    }
//
//    func loadListItems(using request: NSFetchRequest<ListItem> = ListItem.fetchRequest()) {
//        do {
//            items = try context.fetch(request)
//        } catch {
//            print("Fetch request error, could not load item list due to \(error)")
//        }
//    }
//
//    func loadCategories(using request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Fetch request error, could not load category list due to \(error)")
//        }
//    }
//
//}
