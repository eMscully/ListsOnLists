
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
@IBOutlet weak var searchBar: UISearchBar!
    
var itemListArray = [ListItem]()

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
    super.viewDidLoad()
 
    loadData()
    
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
                self.itemListArray.append(newItem)
                self.saveData()
            }
        
        alert.addTextField { (alertTextField) in
           textField = alertTextField
            alertTextField.placeholder = "Create new item"
          }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }
//MARK: - Core Data create and read methods:
    func saveData(){
        do {
        try context.save()
        }
        catch {
        print("Error saving context: \(error)")
    }
        self.tableView.reloadData()
    }
    

                                                            //parameter's default value:
    func loadData(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()){
        

        do {
          itemListArray = try context.fetch(request)
        }
        catch {
            print("Fetch request error: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - EXTENSION FOR TABLE VIEW DELEGATE AND DATA SOURCE METHODS:

extension HomeViewController {
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListArray.count
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.8044921756, green: 0.6836064458, blue: 0.9757086635, alpha: 1)
    
        let item = itemListArray[indexPath.row]
        cell.textLabel?.text = item.title
  
  
        cell.accessoryType = item.isComplete ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        itemListArray[indexPath.row].isComplete.toggle()
        saveData()
        tableView.reloadData()
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

        loadData(with: request)
    }
    
  
    //MARK: - This search bar delegate method acts as a listener/observer of all action that occurs in the search bar field and is triggered every time a change is made in real-time. You can isolate particular time points as needed by your app inside this method.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        //This line of code is saying that when the "character"/letter count in the search textfield is zero then the table view list should reload and list all items again instead of the shortened list from the user's old search query.
        
        //NOTE that the PLACEHOLDER TEXT count is separate from the search bar's "TEXT" count. The code below will work as it should even though technically the search bar appears to have content in it still due to the placeholder text. if there's technically "text" in the search bar because it is seaparate from PLACEHOLDER TEXT.
        if searchBar.text?.count == 0 {
            loadData()
            
            // To dismiss the keyboard and the search bar text field's blinking cursor you need to resign the search bar as the first responder.    IMPORTANT NOTE --> Whenever your app is actively in session, it is good practice to grab a reference to the main view controller whenever you are writing code that directly effects the UI appearance and properties to ensure that You should grab a reference to the main view controller anytime you're writing code that effects the UI view while app is actively in session
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
            
        }
    }


}
 

