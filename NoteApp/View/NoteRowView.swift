//
//  NoteModel.swift
//  NoteApp
//
//  Created by Robert on 15.04.25.
//

import SwiftUI

struct NoteRowView: View {
    private var note: Note
    private var onToggleCompleted: (() -> Void)
    @State private var isCompleted: Bool
    
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
        ZStack {
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

            VStack(spacing: 0) {
                Spacer()

                HStack() {
                    Text("\(note.title)")
                        .font(.title)
                        .padding(.leading, 8)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        isCompleted.toggle()
                        onToggleCompleted()
                    } label: {
                        Image(systemName: "checkmark.circle")
                            .padding(.trailing, 8)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundColor(isCompleted ? .green : .black)
                    }
                    .background(
                        Color.white
                            .padding()
                    )
                }
                .padding(.bottom, 5)
                                            
                HStack(alignment: .bottom) {
                    Text("\(note.description)")
                        .font(.callout)
                        .padding(.leading, 8)
                        .fontWeight(.bold)
                    Spacer()
                    Text(formattedDate)
                        .font(.caption)
                        .padding(.trailing, 8)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 4)
                
                Color.gray
                    .frame(height: 18)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
