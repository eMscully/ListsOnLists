
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
var itemListArray = [ListItem]()

 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
        super.viewDidLoad()
 
    loadData()
    
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
    func loadData(){
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        do {
          itemListArray = try context.fetch(request)
        }
        catch {
            print("Fetch request error: \(error)")
        }
    
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
  
        // USING TERNARY OPERATOR FOR SHORTER CODE:
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
    
    // This is the first search bar delegate method you should invoke because when its triggered it officially begins "the search" (aka enables you to work with the feedback you're getting from user interaction. This is also the time point where you should query the database and try to retrieve the data the user is looking for
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Step 1: In order to read data in the database (and specifically retrieve the stored data that matches the user's query) you need to create a new NSFetchRequest:
   
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
        //Step 2: Now that the request object is created, write code that MODIFIES the request based on the user's search query. In order to query objects using Core Data you need to use NSPredicate. NSPredicate applies logical conditions and essentially structures the query request based on data comparisons and String format comparisons:
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        //Step 3: Now that the query structure is complete, ADD the query predicate to the request:
        
        request.predicate = predicate
        
        //Step 4: To SORT the data that is returned from the fetch request into, you can customize how the data is ordered by using an NSSortDescriptor:
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
                                                            //NOTE: ^ ascending means alphabetical. if true then the table view list will be alphabetically ordered
        
        //Step 5: You need to add the sort descriptor to the request (just like you needed to add the predicate to the request:
        
        request.sortDescriptors = [sortDescriptor]
        
        //Step 6: Now that the request is officially configured and ready, invoke the fetch method to retrieve saved data that matches the request specified
        
        do {
            itemListArray = try context.fetch(request)
        } catch {
            print("Error retrieving queried data: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        <#code#>
//    }
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        <#code#>
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        <#code#>
//    }
}
