
import UIKit
import SwipeCellKit
import ChameleonFramework



class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
 

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
//MARK: - This superclass method ensures that subclasses can use a SwipeTableViewCell in place of UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell") as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateData(at: indexPath)
        }
            
            deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = UIColor.flatGreen()
            return [deleteAction]
                }
    

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateData(at indexPath: IndexPath) {
            
    }

}



    
