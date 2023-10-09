//
//  AgendaApp.swift
//  Agenda
//
//  Created by Andrew Koo on 10/9/23.
//

import SwiftUI

@main
struct AgendaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
