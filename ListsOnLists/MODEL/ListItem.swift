
import Foundation

struct ListItem {
    
    let title: String?
    let bodyText: String?
    var isComplete: Bool?
    
    init(title: String, bodyText: String, completed: Bool){
        self.title = title
        self.bodyText = bodyText
        self.isComplete = completed
    }
  
    
    
}



