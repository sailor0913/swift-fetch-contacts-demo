//
//  Fetch_ContactsApp.swift
//  Fetch Contacts
//
//  Created by ryp on 2023/8/22.
//

import SwiftUI

@main
struct Fetch_ContactsApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    private let coreDataStack = CoreDataStack(modelName: "ContactsModel")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CoreDataStack)
                .environment(\.managedObjectContext, coreDataStack.managedObjectContext)
                .onChange(of: scenePhase) { _ in
                    coreDataStack.save()
                }
                .onAppear{
                    addContacts(to: coreDataStack)
                }
        }
    }
}
