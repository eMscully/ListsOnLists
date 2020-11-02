
import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Inverse relationship linking list item back with its parent category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
