
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
var itemListArray = [ListItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
        super.viewDidLoad()
 
    loadData()
    }
    //MARK: - Table View Methods
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemListArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
           
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
        } catch {
            print("Fetch request error: \(error)")
        }
    
    }
}
