
import Foundation
import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

     var categories : Results<Category>?
     var category = Category()
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
 func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
 }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
    }
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
            
            self.save(category: newCategory)
    
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
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = super.tableView(tableView, cellForRowAt: indexPath)

    cell.textLabel?.text = categories?[indexPath.row].categoryName ?? "No categories added yet"

    return cell
    }
    
    
  //MARK: - Storyboard Segue at selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when user selects category this method should trigger a segue to the item list view controller that corresponds to its parent category
        
        performSegue(withIdentifier: "goToListItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! ItemViewController
            
        if let indexPath = tableView.indexPathForSelectedRow {
            nextViewController.selectedCategory = categories?[indexPath.row]
        }
    }
}


