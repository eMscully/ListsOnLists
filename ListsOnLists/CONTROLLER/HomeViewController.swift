
import UIKit

class HomeViewController: UITableViewController {
    

      var itemListArray = [ListItem]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListArray = [ListItem(title: "Make fruit smoothie", isComplete: false), ListItem(title: "Give Phe a bath", isComplete: false), ListItem(title: "Study videos from beginner app dev module", isComplete: true)]
    
      
        
        
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
     
        // need to create a local TEXT FIELD VARIABLE in order to broaden scope since .addTextField function comes AFTER the alert pops up. The time point at which you obtain the information about what the user has typed in the alert happens inside the ACTION code block below since this code block is where you define what happens after user presses the "Add" button when they've completed typing:
                        var textField = UITextField()
       
         let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = ListItem(title: textField.text!, isComplete: false)
            self.itemListArray.append(newItem)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
           textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        
        
        alert.addAction(action)
    
        
        present(alert, animated: true, completion: nil)
        
       
        }
      

    
//MARK: - Table View Methods
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = itemListArray[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
  
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}


        
        

