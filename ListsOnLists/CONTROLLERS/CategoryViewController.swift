
import Foundation
import UIKit
import RealmSwift



class CategoryViewController: SwipeTableViewController {

     var categories : Results<Category>?
     var category = Category()
     let realm = try! Realm()
    
    
override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = GradientColor(gradientStyle: UIGradientStyle.topToBottom, frame: CGRect(), colors: [UIColor.randomFlat()])
        
        loadCategories()

    }
  //MARK: - Realm Data Manipulation methods
    
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
    
    //Use the superclass updateData model and override it in order to create a delete Realm data method for this view controller:
    
    override func updateData(at indexPath: IndexPath) {
    if let categoryToDelete = self.categories?[indexPath.row] {
        do {
            try self.realm.write {
                self.realm.delete(categoryToDelete)
            }
        } catch {
            print("Error deleting category due to: \(error)")
        }
    }
}

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        presentAlertTextField()
    }
}
//MARK: - EXTENSION ---> Alert Text Field
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

//MARK: - EXTENSION  ----> Table View Datasource and Delegate Methods
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //since this view controller subclasses the swipe table view controller, access the superclass' functionality by tapping into super.tableView so you can use the SwipeTableViewCell type:
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


