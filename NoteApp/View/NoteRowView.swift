//
//  NoteModel.swift
//  NoteApp
//
//  Created by Robert on 15.04.25.
//

import SwiftUI

struct NoteRowView: View {
    var note: Note
    var onToggleCompleted: (() -> Void)
    @State var isCompleted: Bool 
    
    init(note: Note, onToggleCompleted: @escaping () -> Void) {
        self.note = note
        self.onToggleCompleted = onToggleCompleted
        self.isCompleted = note.isCompleted
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(note.creationDate) {
            return "Today \(formatter.string(from: note.creationDate))"
        } else if calendar.isDateInYesterday(note.creationDate) {
            return "Tomorrow в \(formatter.string(from: note.creationDate))"
        } else {
            let dayFormatter = DateFormatter()
            dayFormatter.locale = Locale(identifier: "ru_RU")
            dayFormatter.dateFormat = "d MMMM"
            
            return "\(dayFormatter.string(from: note.creationDate)) в \(formatter.string(from: note.creationDate))"
        }
    }
    
    var body: some View {
            HStack() {
                Text("\(note.title)")
                    .font(.title)
                    .padding(.leading)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    isCompleted.toggle()
                    onToggleCompleted()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .padding(.trailing, 10)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(isCompleted ? .green : .black)
                }
            }
        
            Spacer()
        
            HStack {
                Text("\(note.description)")
                    .font(.callout)
                    .padding(.leading)
                    .fontWeight(.bold)
                Spacer()
                Text(formattedDate)
                    .font(.caption)
                    .padding(.trailing, 10)
                    .foregroundColor(.gray)
            }
            Color.gray
        }
    }
