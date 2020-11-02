
import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false 
}
