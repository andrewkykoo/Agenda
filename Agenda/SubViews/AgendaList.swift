//
//  AgendaList.swift
//  Agenda
//
//  Created by Andrew Koo on 10/11/23.
//

import SwiftUI

struct AgendaList: View {
    @Binding var currentTab: String
    var agenda: FetchedResults<Agenda>
    @StateObject var agendaModel = AgendaViewModel()

    var body: some View {
        LazyVStack(spacing: 20) {
            DynamicFilteredView(currentTab: currentTab) { (agenda: Agenda) in
                AgendaRow(agenda: agenda, agendaModel: agendaModel)
            }
        }
        .padding(.top, 20)
    }
}
