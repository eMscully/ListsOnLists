
import UIKit
import RealmSwift


class ItemViewController: SwipeTableViewController {
    
@IBOutlet weak var searchBar: UISearchBar!

        let realm = try! Realm()
        var itemsList: Results<ListItem>?
        var selectedCategory: Category? {
                didSet {
                    loadList()
                }
            }
    
override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.becomeFirstResponder()
    changeUI()
    self.navigationController?.hidesNavigationBarHairline = true

    searchBar.searchTextField.textColor = .white
    
    }
   
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.categoryName ?? "Lists on Lists"        
    }
    
//MARK: - Realm Data Manipulation Methods
 func loadList(){
         itemsList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
         tableView.reloadData()
        }
    
    override func updateData(at indexPath: IndexPath) {
        if let itemToDelete = self.itemsList?[indexPath.row] {
            do {
                try realm.write  {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item due to: \(error)")
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
        
    }
           
}
 //MARK: - EXTENSION ----> Alert Text Field
extension ItemViewController {
    
    func presentAlertTextField(){
        
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
}
}

//MARK: - TableView Datasource and Delegate methods:
extension ItemViewController {
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
     
    if let item = itemsList?[indexPath.row] {
        
        
        cell.backgroundColor = view.backgroundColor
        
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat:true)
  
        cell.textLabel?.text = item.title
   
        cell.accessoryType = item.isComplete ? .checkmark : .none
        
}   else {
     
        cell.textLabel?.text =  "Add first item"
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
