
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
@IBOutlet weak var searchBar: UISearchBar!
    

    var items = [ListItem]()
    var selectedCategory: Category? {
        didSet {
            loadList()
            tableView.reloadData()
        }
    }
    var dataManager = DataModelManager.shared
    let context = DataModelManager.shared.context
   

override func viewDidLoad() {
    super.viewDidLoad()
   

    
    
    //MARK: - Set search bar as first responder in view did load so that the search text field is focused and has a blinking cursor
    searchBar.becomeFirstResponder()
    }
    

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                self.tableView.reloadData()
            
                let newItem = ListItem(context: self.context)
                newItem.title = textField.text!
                newItem.isComplete = false
                newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
               
                
                self.saveList()
                
            }
        
        alert.addTextField { (alertTextField) in
           textField = alertTextField
            alertTextField.placeholder = "Create new item"
          }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }

   //MARK: - CREATED A BRAND NEW CORE DATA READ FUNCTION FOR USE WHEN VIEW INITIALLY LOADS UP. EVERYWHERE ELSE IN MY CODE I AM USING THE DATA MODEL MANAGER SINGLETON READ METHOD INSTEAD**. OFFICIALLY DEBUGGED CCODE SINCE LAST GIT COMMIT!
   
    func loadList(using request: NSFetchRequest<ListItem> = ListItem.fetchRequest()){

        do {
         items = try context.fetch(request)
        }
        catch {
            print("Fetch request error: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveList(){
        do {
            try context.save()
        } catch {
            print("Error loading saved items list due to: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - EXTENSION FOR TABLE VIEW DELEGATE AND DATA SOURCE METHODS:

extension HomeViewController {
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.8044921756, green: 0.6836064458, blue: 0.9757086635, alpha: 1)
    
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
  
  
        cell.accessoryType = item.isComplete ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        items[indexPath.row].isComplete.toggle()
        loadList()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
//MARK: - EXTENSION FOR SEARCH BAR DELEGATE METHODS
extension HomeViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = true
        
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        self.loadList(using: request)

    }
    
  
    //MARK: - This search bar delegate method acts as a listener/observer of all action that occurs in the search bar field and is triggered every time a change is made in real-time. You can isolate particular time points as needed by your app inside this method.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 
        if searchBar.text?.count == 0 {
            loadList()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
            
        }
    }


}
 

