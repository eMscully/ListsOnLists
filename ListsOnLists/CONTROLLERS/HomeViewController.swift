
import UIKit
import CoreData

class HomeViewController: UITableViewController {
    
var itemListArray = [ListItem]()
  
//MARK: - STEP 1: CREATE THE CORE DATA CONTEXT ATTRIBUTE AS A GLOBAL VARIABLE THAT IS AN OBJECT OF THE APP DELEGATE CLASS

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
        super.viewDidLoad()
        
     
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
 //MARK: - STEP 2: REWRITE CODE SO THAT NEW ITEM IS AN NSManaged OBJECT BY USING THE CORE DATA ENTITY'S CONTEXT METHOD AND PASSING IN THE GLOBAL CONTEXT VARIABLE FOR THE ARGUMENT
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
    //MARK: - STEP 3: REWRITE SAVE DATA METHOD FROM PREVIOUS NSCODER PERSISTENCE TO CORE DATA CONTAINER PERSISTENCE BY INVOKING THE CONTEXT.SAVE() METHOD FROM APP DELEGATE
    func saveData(){
        do {
        try context.save()
        }
        catch {
        print("Error saving context: \(error)")
    }
        self.tableView.reloadData()
    }

    

}
