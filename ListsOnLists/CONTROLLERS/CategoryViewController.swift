
import Foundation
import UIKit


class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}

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


