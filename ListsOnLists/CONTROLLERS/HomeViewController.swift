
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
            var textField = UITextField()
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
        let item = itemListArray[indexPath.row]
        
        cell.textLabel?.text = item.title
  
        // REWROTE LINES 62-66 USING TERNARY OPERATOR FOR SHORTER CODE:
        cell.accessoryType = item.isComplete ? .checkmark : .none

//        if item.isComplete == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        itemListArray[indexPath.row].isComplete.toggle()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
