//
//  AppDelegate.swift
//  ToDoList
//
//  Created by LillyC on 9/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
  //      print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
          _ = try Realm()
           
        }
        catch{
            print("Error initialize Realm \(error)")
        }
        
        return true
    }

    
   


}

