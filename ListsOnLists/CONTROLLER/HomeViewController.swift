
import UIKit

class HomeViewController: UITableViewController {
    

    
      var itemListArray = [ListItem]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
      itemListArray = [ListItem(title: "Make fruit smoothie", bodyText: "Get on track with making a smoothie every morning!", completed: false), ListItem(title: "Give Phe a bath", bodyText: "He needs one ASAP", completed: false), ListItem(title: "Revisit beginner module To Do App", bodyText: "Testing my skills", completed: true)]
        
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = itemListArray[indexPath.row].title
        
        
        return cell
    }
}

