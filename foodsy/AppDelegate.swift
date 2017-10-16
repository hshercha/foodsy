//
//  AppDelegate.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "cravely"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey
                configuration.server = "https://cravely.herokuapp.com/parse"
            })
        )
        APIToken.initializeTokensInBackground()
        if User.currentUser != nil {
            let ingredientListStoryboard = UIStoryboard(name: "IngredientList", bundle: nil)
            let ingredientListNavigationController = ingredientListStoryboard.instantiateViewController(withIdentifier: "IngredientsListNavigation") as! UINavigationController
            let ingredientListViewController = ingredientListNavigationController.topViewController as! IngredientsListViewController
            ingredientListViewController.tabBarItem.title = "Ingredients"
            
            let recipeListStoryboard = UIStoryboard(name: "RecipeList", bundle: nil)
            let recipeListNavigationController = recipeListStoryboard.instantiateViewController(withIdentifier: "RecipeListNavigationController") as! UINavigationController
            let recipeListViewController = recipeListNavigationController.topViewController as! RecipeListViewController
            recipeListViewController.tabBarItem.title = "Recipes"
            
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
            let profileViewController = profileNavigationController.topViewController as! ProfileViewController
            profileViewController.tabBarItem.title = "Recipes"
            
            
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [ingredientListNavigationController, recipeListNavigationController, profileNavigationController]
            
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
            
            let appearance = UITabBarItem.appearance()
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font:UIFont(name: "Helvetica Neue", size: 20)]
            appearance.setTitleTextAttributes(attributes, for: [])
            
            print("there is a current user")
        } else {
            print("no current user")
            let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            window?.rootViewController = loginViewController
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, queue: OperationQueue.main) { (notification: Notification) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "foodsy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.handleOpenUrl(url: url)
        return true
    }

}

