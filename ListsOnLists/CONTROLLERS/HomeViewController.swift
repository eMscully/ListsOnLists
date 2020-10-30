
import UIKit

class HomeViewController: UITableViewController {
    
   var itemListArray = [ListItem]()

    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
    let listItem = ListItem()
        listItem.title = "Give Phe a bath!"
        itemListArray.append(listItem)
        
        
    let listItem2 = ListItem()
        listItem2.title = "Find a good found-footage horror movie!"
        itemListArray.append(listItem2)
     
      
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
// need to create a local TEXT FIELD VARIABLE in order to broaden scope since .addTextField function comes AFTER the alert pops up. The time point at which you obtain the information about what the user has typed in the alert happens inside the ACTION code block below since this code block is where you define what happens after user presses the "Add" button when they've completed typing:
        
        var textField = UITextField()
       
        //Create UITextField Alert:
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
         
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newItem = ListItem()
            newItem.title = textField.text!
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
  
        //MARK: - EDIT / CONDENSE CODE BY TOGGLING CHECK MARK ACCESSORY AT THIS TIME POINT. DELETE LINES 85-89; BUT MAKE SURE TO RELOAD TABLE VIEW OR ELSE ACCESSORY TYPE WON'T WORK
        if itemListArray[indexPath.row].isComplete == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        itemListArray[indexPath.row].isComplete.toggle()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


        
        

