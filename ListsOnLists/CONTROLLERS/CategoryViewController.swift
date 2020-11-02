
import Foundation
import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
//   private let realm = try! Realm()
 
   private var categories = [Category]()
    private var category = Category()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
//       loadCategories()
        
  
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
        
    }
    
    
//    func save(category: Category){
//
//        do {
//            try realm.write {
//
//                realm.add(category)
//        }
//    }
//        catch {
//            print("Error saving category: \(error)")
//        }
//        tableView.reloadData()
//    }
    
//    func loadData(){
//
//    }

}
//MARK: - Created a UIAlert text field in extension to break up code. The method is invoked when add new category button is pressed.
extension CategoryViewController {
    func presentAlertTextField(){
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.tableView.reloadData()
            
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            self.categories.append(newCategory)
            self.category.save(category: newCategory)
            self.tableView.reloadData()
            
          //  self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new category"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
//MARK: - Table View Datasource and Delegate Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.5273327231, green: 0.1593059003, blue: 0.4471139908, alpha: 1)
        
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.categoryName
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when user selects category this method should trigger a segue to the item list view controller that corresponds to its parent category
        
        performSegue(withIdentifier: "goToListItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! HomeViewController
            
        if let indexPath = tableView.indexPathForSelectedRow {
            nextViewController.selectedCategory = categories[indexPath.row]
        }
    }
}


