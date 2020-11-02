
import Foundation
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    var dataManager = DataModelManager.shared
    let context = DataModelManager.shared.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       loadCategories()
        
  
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
        
    }
    
    
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("Error loading saved items list due to: \(error)")
        }
        tableView.reloadData()
    }

    
    func loadCategories(using request:  NSFetchRequest<Category> = Category.fetchRequest()) {
        
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
            
            
            self.saveCategory()
            
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
        cell.textLabel?.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        
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


