
import UIKit

class HomeViewController: UITableViewController {
    
var itemListArray = [ListItem]()
//STEP 1: CREATE THE DATA FILE PATH TO LOCAL FILE SYSTEM. CREATE AS A GLOBAL VARIABLE!
    
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

override func viewDidLoad() {
        super.viewDidLoad()
         
  //  loadData()

     
    }
//STEP 2: CREATE AN ENCODER FOR THE DATA YOU WANT TO SAVE AT THE DATA FILE PATH LOCATION YOU CREATED
    //without encoding the data then the appended path component you initiated will not appear yet... it does not show up in app sandbox until there is encoded data to populate it!
    //This method gets called at every time point in your code where data has changed and needs to be saved!!
//    func saveData(){
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.itemListArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error saving data: \(error)")
//        }
//    }
//STEP 3: CREATE A DECODER FOR THE SAVED DATA SO THAT YOU CAN OBTAIN ALL THE SAVED INFO AT APP RUN TIME.  CALL THIS METHOD IN VIEWDIDLOAD
//    func loadData(){
//        if FileManager.default.fileExists(atPath: dataFilePath!.path){
//
//            do {
//                let data = try Data(contentsOf: dataFilePath!)
//                let decoder = PropertyListDecoder()
//                itemListArray = try decoder.decode([ListItem].self, from: data)
//            } catch {
//                print("Error decoding saved data: \(error)")
//            }
//    }
//    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                
                let newItem = ListItem()
                newItem.title = textField.text!
                self.itemListArray.append(newItem)
//STEP 4: SAVE DATA IS CALLED HERE BECAUSE THIS IS THE TIME POINT WHEN A USER HAS ADDED A NEW TO DO LIST ITEM
             //   self.saveData()
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
  
        // USING TERNARY OPERATOR FOR SHORTER CODE:
        cell.accessoryType = item.isComplete ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        itemListArray[indexPath.row].isComplete.toggle()
//STEP 5: SAVE DATA IS CALLED AGAIN BECAUSE THE USER HAS TOGGLED THE CHECKMARK ACCESSORY DUE TO AN ITEM BEING DONE OR NOT DONE. ANYTIME THE USER CHANGES SOMETHING FROM DONE TO NOT DONE OR VICE VERSA THEN THIS INFO NEEDS TO BE SAVED!!
      //  saveData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
