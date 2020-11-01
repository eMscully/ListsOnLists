
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
@IBOutlet weak var searchBar: UISearchBar!
    
//var itemListArray = [ListItem]()

    var itemListArray = DataModelManager.shared.items
    
    var dataManager = DataModelManager.shared
   
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
    super.viewDidLoad()
 
    dataManager.loadListItems()
    tableView.reloadData()
    
 //   loadData()
    
    //MARK: - Set search bar as first responder in view did load so that the search text field is focused and has a blinking cursor
    searchBar.becomeFirstResponder()
    }

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                self.tableView.reloadData()
            
                let newItem = ListItem(context: self.dataManager.context)
//                let newItem = ListItem(context: self.context)
                newItem.title = textField.text!
                newItem.isComplete = false
                self.itemListArray.append(newItem)
               
                
                self.dataManager.saveData()
                self.tableView.reloadData()
                //self.saveData()
            }
        
        alert.addTextField { (alertTextField) in
           textField = alertTextField
            alertTextField.placeholder = "Create new item"
          }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }
////MARK: - Core Data create and read methods:
//    func saveData(){
//        do {
//        try context.save()
//        }
//        catch {
//        print("Error saving context: \(error)")
//    }
//        self.tableView.reloadData()
//    }
//
//
//                                                            //parameter's default value:
//    func loadData(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()){
//
//
//        do {
//          itemListArray = try context.fetch(request)
//        }
//        catch {
//            print("Fetch request error: \(error)")
//        }
//        tableView.reloadData()
//    }
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
        dataManager.saveData()
        
       // saveData()
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
        dataManager.loadListItems(using: request)
        tableView.reloadData()
        
//        loadData(with: request)
    }
    
  
    //MARK: - This search bar delegate method acts as a listener/observer of all action that occurs in the search bar field and is triggered every time a change is made in real-time. You can isolate particular time points as needed by your app inside this method.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 
        if searchBar.text?.count == 0 {
            dataManager.loadListItems()
            tableView.reloadData()
            //loadData()

            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
            
        }
    }


}
 

