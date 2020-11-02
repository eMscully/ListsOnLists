
import UIKit
import RealmSwift
import SwipeCellKit

class ItemViewController: UITableViewController {
    
@IBOutlet weak var searchBar: UISearchBar!

    private let realm = try! Realm()
  
    private var itemsList: Results<ListItem>?
   
    var selectedCategory: Category? {
        didSet {
            loadList()
        }
    }
override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.becomeFirstResponder()
    }
    
    private func loadList(){
         itemsList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
         tableView.reloadData()
        }
    

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
               
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                        let newItem = ListItem()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item: \(error)")
                    }
                }
                self.tableView.reloadData()
            }

        alert.addTextField { (alertTextField) in
           textField = alertTextField
            alertTextField.placeholder = "Create new item"
          }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
}
}
//MARK: - EXTENSION FOR TABLE VIEW DELEGATE AND DATA SOURCE METHODS:

extension ItemViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let deletedItem = self.itemsList?[indexPath.row] {
            do {
                try self.realm.write {
                    
                    self.realm.delete(deletedItem)
                }
                }
             catch {
                print("Swipe action error, deletion failed: \(error)")
            
        }
            }
        }
        deleteAction.image = UIImage(named: "trash")
        return [deleteAction]

    }
          
        

         

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as!SwipeTableViewCell
    cell.delegate = self
    
    
    
    if let item = itemsList?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none
    } else {
        cell.textLabel?.text = "Add first item"
    }
    return cell
    }
    
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemsList?[indexPath.row] {
            do {
                try realm.write{
                    item.isComplete.toggle()
                }
            } catch {
                print("Error saving item completion state: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
//MARK: - EXTENSION FOR SEARCH BAR DELEGATE METHODS
extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = true
      
        //MARK: - QUERYING USING REALM <FILTERING AND SORTING QUERY RESULTS>
        
        // Results are sorted by oldest to newest
        itemsList = itemsList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
                loadList()
                    DispatchQueue.main.async {
                        searchBar.resignFirstResponder()
            }
        }
    }

}
