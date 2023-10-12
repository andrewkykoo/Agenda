//
//  Home.swift
//  Agenda
//
//  Created by Andrew Koo on 10/9/23.
//

import SwiftUI

struct Home: View {
    @StateObject var agendaModel: AgendaViewModel = .init()

    // MARK: - Matched Geometry Namespace
    @Namespace var animation
    
    // MARK: - Fetching Agenda
    @FetchRequest(entity: Agenda.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Agenda.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var agendas: FetchedResults<Agenda>
    
    var todayAgendasCount: Int {
        return agendas.filter {
            Calendar.current.isDateInToday($0.deadline ?? Date())
        }.count
    }
    
    var upcomingAgendasCount: Int {
        return agendas.filter {
            let isAfterToday = $0.deadline ?? Date() > Date()
            return isAfterToday && !Calendar.current.isDateInToday($0.deadline ?? Date())
        }.count
    }
    
    func agendaWord(forCount count: Int) -> String {
        count == 1 ? "agenda" : "agendas"
    }
    
    var body: some View {
        
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Here is your Agenda List")
                            .font(.title2.bold())
                        
                        let todayAgendasCount = agendaModel.countOfUncompletedAgendas(for: Array(agendas), isToday: true)
                        let upcomingAgendasCount = agendaModel.countOfUncompletedAgendas(for: Array(agendas), isToday: false)
                        
                        let todayAgendaWord = agendaWord(forCount: todayAgendasCount)
                        let upcomingAgendaWord = agendaWord(forCount: upcomingAgendasCount)
                        
                        Text("You have \(todayAgendasCount) \(todayAgendaWord) today and \(upcomingAgendasCount) \(upcomingAgendaWord) upcoming")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color("TextColor"))
                    .padding(.vertical)
                    
                    CustomSegmentedBar(currentTab: $agendaModel.currentTab, animation: animation)
                        .padding(.top, 5)
                    
                    // MARK: - Agenda View
                    AgendaList(currentTab: $agendaModel.currentTab, agenda: agendas, agendaModel: agendaModel)
                }
                .padding()
            }
            .overlay(alignment: .bottom) {
                
                // MARK: - Add Agenda Button
                Button(action: {
                    agendaModel.openEditAgenda.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        
                        Text("Add New")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Color("ButtonColor"))
                    )
                }
            }
            .fullScreenCover(isPresented: $agendaModel.openEditAgenda) {
                agendaModel.resetAgendaData()
            } content: {
                AddOrEditAgenda()
                    .environmentObject(agendaModel)
            }
        }
        .foregroundStyle(Color.primary)
    }
}


#Preview {
    Home()
}

#Preview {
    Home()
        .environment(\.colorScheme, .dark)
}
