
import Foundation
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    var dataManager = DataModelManager.shared
    let context = DataModelManager.shared.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       loadCategoryList()
        
  
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
        
    }
    
    func loadCategoryList(with request:  NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        }
        catch {
            print("Error loading category list: \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK: - Created a UIAlert text field in extension to break up code. The method is invoked when add new category button is pressed.
extension CategoryViewController {
    func presentAlertTextField(){
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.tableView.reloadData()
            
            let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            self.categories.append(newCategory)
            
            
            self.dataManager.saveData()
            self.tableView.reloadData()
            
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
        
        let newCategory = categories[indexPath.row]
        cell.textLabel?.text = newCategory.categoryName
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}








//MARK: - Temporarily commented out until ready to configure. Storing the segue identifier name for reference later
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       segue identifier name is  goToListItems
//
//    }


