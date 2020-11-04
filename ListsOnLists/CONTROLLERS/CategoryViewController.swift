
import Foundation
import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

     var categories : Results<Category>?
     var category = Category()
     let realm = try! Realm()
    
   
override func viewDidLoad() {
        super.viewDidLoad()
    
    self.navigationController?.hidesNavigationBarHairline = true
    
    let defaultColor:[UIColor] = [
        FlatWhite(),FlatWhiteDark(), #colorLiteral(red: 0.2419321835, green: 0.4332072735, blue: 0.5136573911, alpha: 1)
    ]
    view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: defaultColor)
    navigationController?.navigationBar.backgroundColor = .clear
  
  //MARK: - Alert that tells user the color palette button will change gradient background color; click OK to exit alert
    let changeColorAlert = UIAlertController(title: "Welcome!", message: "To change the background gradient color click the color palette button", preferredStyle: .alert)
    changeColorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    present(changeColorAlert, animated: true, completion: nil)
    
    
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
    
    @IBAction func changeColorSchemeButtonPresed(_ sender: UIBarButtonItem) {
        changeUI()
    }
    
}

//MARK: - EXTENSION ---> Changing background color scheme
extension CategoryViewController {
    func changeUI() {
 
        let green = [FlatPowderBlueDark(), FlatMint(), FlatWhite()]
        let yellow = [FlatYellow(), FlatYellowDark(), FlatLimeDark(), FlatOrange()]
        let pink = [FlatPink(),FlatPinkDark(),FlatWatermelon() ,FlatWhite()]
        let red = [FlatRed(), FlatRedDark(), FlatWatermelon(), FlatWatermelonDark()]
        let blue = [FlatSkyBlue(), FlatSkyBlueDark(), FlatBlueDark(), FlatBlue(), FlatWhite()]
        let purple = [FlatPurple(), FlatPurpleDark(), FlatMagenta(), FlatMagentaDark()]
        let orange = [FlatOrange(), FlatOrangeDark(), FlatYellow(), FlatYellowDark(), FlatRedDark()]
        
        let gradientColorSchemes  = [green, yellow, pink, red, blue, purple, orange]
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: gradientColorSchemes.randomElement()!)
        self.setStatusBarStyle(UIStatusBarStyleContrast)

        
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - EXTENSION  ----> Table View Datasource and Delegate Methods
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
    if let category = categories?[indexPath.row] {
            cell.backgroundColor = UIColor.clear

// Set the cell's text color property to contrast with whatever the gradient color of the entire background is (the text color does not depend on the CELL background)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: view.backgroundColor!, isFlat: true)
           
            cell.textLabel?.text = category.categoryName
        }
        else {
            cell.textLabel?.text = "No categories added yet"
        }
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


