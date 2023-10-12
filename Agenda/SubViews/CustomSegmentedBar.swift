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
        HStack(spacing: 5) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.subheadline)
                    .scaleEffect(0.9)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background {
                        if currentTab == tab {
                            Capsule()
                                .fill(Color(.systemGray3))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            currentTab = tab
                        }
                    }
            }
        }
    }
}
