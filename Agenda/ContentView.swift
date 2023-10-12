//
//  ContentView.swift
//  Agenda
//
//  Created by Andrew Koo on 10/9/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor") ?? UIColor.white]

    }
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Agenda")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
