//
//  CustomSegmentedBar.swift
//  Agenda
//
//  Created by Andrew Koo on 10/11/23.
//

import SwiftUI

struct CustomSegmentedBar: View {
    @Binding var currentTab: String
    var animation: Namespace.ID
    
    let tabs = ["Today", "Upcoming", "Complete", "Incomplete"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                        .font(.subheadline)
                        .scaleEffect(0.9)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                currentTab = tab
                            }
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .opacity(currentTab == tab ? 1 : 0)
                                .animation(.easeIn, value: currentTab)
                            ,alignment: .bottom
                        )
                }
            }
            .foregroundStyle(Color("TextColor"))
        }
    }
    
    private func underlineAlignment() -> Alignment {
        switch currentTab {
        case "Today":
            return .leading
        case "Upcoming":
            return .center
        case "Complete":
            return .trailing
        default:
            return .bottom
        }
    }
}

