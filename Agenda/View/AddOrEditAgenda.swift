//
//  AddNewAgenda.swift
//  Agenda
//
//  Created by Andrew Koo on 10/9/23.
//

import SwiftUI

struct AddOrEditAgenda: View {
    @EnvironmentObject var agendaModel: AgendaViewModel
    @Environment(\.self) var env
    @Namespace var animation
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Edit")
                    .font(.title3.bold())
                    .foregroundStyle(Color("TextColor"))
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button(action: {
                            env.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .foregroundStyle(Color("TextColor"))
                        })
                    }
                    .overlay(alignment: .trailing) {
                        Button(action: {
                            if let editAgenda = agendaModel.editAgenda {
                                env.managedObjectContext.delete(editAgenda)
                                try? env.managedObjectContext.save()
                                env.dismiss()
                            }
                        }, label: {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundColor(Color("RedIconButtonColor"))
                        })
                        .opacity(agendaModel.editAgenda == nil ? 0 : 1)
                    }
                
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("Color")
                        .font(.caption)
                        .foregroundStyle(Color("TextColor"))
                    
                    // MARK: - Sample Card Colors
                    let colors: [String] = ["CustomYellow", "CustomGreen", "CustomBlue", "CustomRed"]
                    
                    HStack(spacing: 15) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 25, height: 25)
                                .background {
                                    if agendaModel.agendaColor == color {
                                        Circle()
                                            .strokeBorder(Color("TextColor"), lineWidth: 10)
                                            .padding(-3)
                                    }
                                }
                                .contentShape(Circle())
                                .onTapGesture {
                                    agendaModel.agendaColor = color
                                }
                        }
                    }
                    .padding(.top, 10)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
                
                Divider()
                    .padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("Title")
                        .font(.caption)
                    TextField("", text: $agendaModel.agendaTitle)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                })
                .foregroundStyle(Color("TextColor"))
                
                Divider()
                    .padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("Deadline")
                        .font(.caption)
                    Text(agendaModel.agendaDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + agendaModel.agendaDeadline.formatted(date: .omitted, time: .shortened))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("TextColor"))
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        agendaModel.showDatePicker.toggle()
                    }, label: {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundStyle(Color("TextColor"))
                    })
                }
                
                Divider()
                
                // MARK: - Sample Agenda Types
                let agendaTypes: [String] = ["Basic", "Urgent", "Important"]
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("Type")
                        .font(.caption)
                        .foregroundStyle(Color("TextColor"))
                    
                    HStack(spacing: 12) {
                        ForEach(agendaTypes, id: \.self) { type in
                            Text(type)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("TextColor"))
                                .background {
                                    if agendaModel.agendaType == type {
                                        Capsule()
                                            .fill(Color("ButtonColor"))
                                            .matchedGeometryEffect(id: "TYPE", in: animation)
                                    } else {
                                        Capsule().strokeBorder(Color("BackgroundColor"))
                                    }
                                }
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        agendaModel.agendaType = type
                                    }
                                }
                        }
                    }
                    .padding(.top, 8)
                })
                .padding(.vertical, 10)
                
                Divider()
                
                // MARK: - Save Button
                Button(action: {
                    if agendaModel.addAgenda(context: env.managedObjectContext) {
                        env.dismiss()
                    }
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                .fill(Color("ButtonColor"))
                        )
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 10)
                .disabled(agendaModel.agendaTitle == "" || agendaModel.agendaColor == "")
                .opacity(agendaModel.agendaTitle == "" || agendaModel.agendaColor == "" ? 0.5 : 1)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .overlay {
                ZStack {
                    if agendaModel.showDatePicker {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture {
                                agendaModel.showDatePicker = false
                            }
                        
                        DatePicker.init("", selection: $agendaModel.agendaDeadline, in: Date.now...Date.distantFuture)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .padding()
                            .background(Color("ButtonColor"), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .padding()
                    }
                }
                .animation(.easeInOut, value: agendaModel.showDatePicker)
            }
        }
    }
}

#Preview {
    AddOrEditAgenda()
        .environmentObject(AgendaViewModel())
}
