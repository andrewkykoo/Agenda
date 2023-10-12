//
//  DynamicFilteredView.swift
//  Agenda
//
//  Created by Andrew Koo on 10/10/23.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, A>: View where A: NSManagedObject {
    // MARK: - Core Data Request
    @FetchRequest var request: FetchedResults<A>
    let content: (A) -> Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (A) -> Content) {
        
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            let filterKey = "deadline"
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            let filterKey = "deadline"
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Incomplete" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            let filterKey = "deadline"
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        } else {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        _request = FetchRequest(entity: A.entity(), sortDescriptors: [.init(keyPath: \Agenda.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No agenda")
                    .font(.callout)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
