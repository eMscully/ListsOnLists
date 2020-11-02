
import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
 

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            
//            if let deleteCategory = self.categories?[indexPath.row] {
//
//            do {
//              try self.realm.write {
//                self.realm.delete(deleteCategory)
//                }
//
//            } catch {
//                print("Error deleting cell: \(error)")
//            }
//        }
    }
        
        deleteAction.image = UIImage(named: "trash")
        return [deleteAction]
            }
        
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }

}
