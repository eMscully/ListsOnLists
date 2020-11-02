
import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName: String = ""
    
    //List is the realm class you need to use when declaring relationships between data containers
    //declare the forward relationship:
    let items = List<ListItem>()
}
