
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        return true
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
     }

     // MARK: - Core Data stack

     lazy var persistentContainer: NSPersistentContainer = {

         let container = NSPersistentContainer(name: "DataModel")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()

     // MARK: - Core Data Saving support; context area is very similar to the staging area of git repository because you can edit and modify your saved data before you "commit" the data context to permanent storage in the persistent container

     func saveContext () {
         let context = persistentContainer.viewContext
         if context.hasChanges {
             do {
                 try context.save()
             } catch {
                
                 let nserror = error as NSError
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
     }



}

