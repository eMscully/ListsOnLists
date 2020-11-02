
import UIKit
import RealmSwift

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
    
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
               
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                        let newItem = ListItem()
                        newItem.title = textField.text!
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

   private func loadList(){
        itemsList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
       }

}
//MARK: - EXTENSION FOR TABLE VIEW DELEGATE AND DATA SOURCE METHODS:

extension ItemViewController {
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.5273327231, green: 0.1593059003, blue: 0.4471139908, alpha: 1)
    
    if let item = itemsList?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none
    } else {
        cell.textLabel?.text = "Add first item"
    }
    return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        //MARK: - 'UPDATE' USING REALM
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
 

