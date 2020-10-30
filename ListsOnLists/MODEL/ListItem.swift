
import Foundation

struct ListItem {
    
    let title: String?
   
    var isComplete = false
    
    init(title: String, isComplete: Bool){
        self.title = title
        self.isComplete = isComplete
    }
  
    
    
}



