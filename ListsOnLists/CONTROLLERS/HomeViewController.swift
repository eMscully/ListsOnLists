
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
    
    /*
     Rewrote this function so that it is reusable throughout source code by having a request parameter and providing the request parameter with a DEFAULT VALUE. Writing the function this way does 2 things:
     1. It eliminates the original hardcoded request and instead makes this method reusable throughout source code because any fetch request configuration can be passed in now;
     2. By providing the request parameter with a DEFAULT VALUE, this gives the method even more reusability because it can be invoked anywhere in the code regardless of whether the time point at which you invoke the method has a request to pass in or not (i.e. such as in viewDidLoad when you want all the saved data to load up as soon as the app launches... this doesn't require a specific fetch request, it simply is trying to retrieve ALL data. By providing this method's request parameter with a default value, it is now SAFE to invoke this method anywhere throughout the source code because even if you don't have a request argument to pass in then its okay because the request already has a default value. 
     */
    func loadData(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()){
        
//        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
    //REFACTORING --->  get rid of the predicate constant and pass it in as the request.predicate's value instead:
    
        //DELETE....  let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
      
        
        //New code:
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        //REFACTOR the sort descriptor code the same way; delete the sort descriptor constant and pass it in as the request.sortDescriptors value instead
        
      //DELETE....  let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        
        //New code:
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
// REFACTORING ---> See notes above; rewrote the original loadData() method so that it is now reusable throughout source code and takes in a specified fetch request. The code below can be replaced with loadData(with: request)
//        do {
//            itemListArray = try context.fetch(request)
//        } catch {
//            print("Error retrieving queried data: \(error)")
//        }
//        tableView.reloadData()
        
        loadData(with: request)
    }
    
}
 

