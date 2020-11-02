
import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    
    
    
    //declare inverse relationship:                                                     //property argument is the name of the forward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    func save(item: ListItem) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving item: \(error)")
        }
    }
    
}
