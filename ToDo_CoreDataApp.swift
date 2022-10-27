//
//  ToDo_CoreDataApp.swift
//  ToDo CoreData
//
//  Created by Fauzan Nugraha on 13/10/22.
//

import SwiftUI

@main
struct ToDo_CoreDataApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer // to call the data
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext) // root view of the application
        }
    }
}
