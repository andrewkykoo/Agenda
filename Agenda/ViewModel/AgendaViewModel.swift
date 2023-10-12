//
//  AgendaViewModel.swift
//  Agenda
//
//  Created by Andrew Koo on 10/9/23.
//

import SwiftUI
import CoreData

class AgendaViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    // MARK: - New Agenda Properties
    @Published var openEditAgenda: Bool = false
    @Published var agendaTitle: String = ""
    @Published var agendaColor: String = ""
    @Published var agendaDeadline: Date = Date()
    @Published var agendaType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: - Editing existing agenda data
    @Published var editAgenda: Agenda?
    
    // MARK: - Adding agenda to core data
    func addAgenda(context: NSManagedObjectContext) -> Bool {
        // MARK: - Updating existing agenda in core data
        var agenda: Agenda!
        if let editAgenda = editAgenda {
            agenda = editAgenda
        } else {
            agenda = Agenda(context: context)
        }
        agenda.title = agendaTitle
        agenda.color = agendaColor
        agenda.deadline = agendaDeadline
        agenda.type = agendaType
        agenda.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // MARK: - Resetting data
    func resetAgendaData() {
        agendaType = "Basic"
        agendaColor = "Yellow"
        agendaTitle = ""
        agendaDeadline = Date()
    }
    
    // MARK: - If edit agenda is availabile, set existing data
    func setupAgenda() {
        if let editAgenda = editAgenda {
            agendaTitle = editAgenda.title ?? ""
            agendaType = editAgenda.type ?? "Basic"
            agendaColor = editAgenda.color ?? "Yellow"
            agendaDeadline = editAgenda.deadline ?? Date()
        }
    }
    
    func deleteAgenda(context: NSManagedObjectContext, agenda: Agenda) {
        context.delete(agenda)
        try? context.save()
    }
}
