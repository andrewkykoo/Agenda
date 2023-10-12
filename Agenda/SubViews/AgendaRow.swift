//
//  AgendaRow.swift
//  Agenda
//
//  Created by Andrew Koo on 10/11/23.
//

import SwiftUI

struct AgendaRow: View {
    var agenda: Agenda
    @ObservedObject var agendaModel: AgendaViewModel
    @Environment(\.managedObjectContext) private var env
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                Text(agenda.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .foregroundStyle(Color("ButtonColor"))
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                
                Spacer()
                
                HStack(spacing: 15) {
                    if !agenda.isCompleted && agendaModel.currentTab != "Incomplete" {
                        Button(action: {
                            agendaModel.editAgenda = agenda
                            agendaModel.openEditAgenda = true
                            agendaModel.setupAgenda()
                        }, label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.black)
                        })
                    }
                    
                    Button(action: {
                        agendaModel.deleteAgenda(context: env, agenda: agenda)
                    }, label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color("RedIconButtonColor"))
                    })
                }
            }
            
            Text(agenda.title ?? "")
                .font(.title2.bold())
                .foregroundStyle(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label(
                        title: { Text((agenda.deadline ?? Date()).formatted(date: .long, time: .omitted)) },
                        icon: { Image(systemName: "calendar") }
                    )
                    .font(.caption)
                    
                    Label(
                        title: { Text((agenda.deadline ?? Date()).formatted(date: .omitted, time: .shortened)) },
                        icon: { Image(systemName: "clock") }
                    )
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("ButtonColor"))

                
                if !agenda.isCompleted && agendaModel.currentTab != "Incomplete" {
                    Button(action: {
                        agenda.isCompleted.toggle()
                        try? env.save()
                    }, label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    })
                }
            }
        })
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(agenda.color ?? "Yellow"))
        }
    }
}
