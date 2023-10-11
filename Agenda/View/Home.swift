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
    
    // MARK: - Environment Values
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hello there")
                        .font(.callout)
                    Text("Here is your Agenda List")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                // MARK: - Agenda View
                AgendaView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: - Add Agenda Button
            Button(action: {
                agendaModel.openEditAgenda.toggle()
            }, label: {
                Label(
                    title: { Text("Add New").font(.callout).fontWeight(.semibold) },
                    icon: { Image(systemName: "plus.app.fill") }
                )
                .foregroundStyle(.white)
                .padding(.vertical, 15)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            })
        }
        .fullScreenCover(isPresented: $agendaModel.openEditAgenda) {
            agendaModel.resetAgendaData()
        } content: {
            AddNewAgenda()
                .environmentObject(agendaModel)
        }
    }
    
    // MARK: - Agenda View
    @ViewBuilder
    func AgendaView() -> some View {
        LazyVStack(spacing: 20) {
            DynamicFilteredView(currentTab: agendaModel.currentTab) { (agenda: Agenda) in
                AgendaRowView(agenda: agenda)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Task Row View
    @ViewBuilder
    func AgendaRowView(agenda: Agenda) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                Text(agenda.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.gray.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: - Edit Button for incomplete agendas
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
                
                if !agenda.isCompleted && agendaModel.currentTab != "Incomplete" {
                    Button(action: {
                        agenda.isCompleted.toggle()
                        try? env.managedObjectContext.save()
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
    
    // MARK: - Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Today", "Upcoming", "Completed", "Incomplete"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundStyle(agendaModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background {
                        if agendaModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            agendaModel.currentTab = tab
                        }
                    }
            }
        }
    }
}




#Preview {
    Home()
}
