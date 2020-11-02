
import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var dateCreated: Date?
    
    
    //declare inverse relationship:                                                     //property argument is the name of the forward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
