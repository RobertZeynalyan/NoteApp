//
//  EditNoteView.swift
//  NoteApp
//
//  Created by Robert on 20.04.25.
//
import SwiftUI

struct EditNoteView: View {
    
    @State var note: Note
    var onSave: (Note) -> Void

    var body: some View {
        VStack(spacing: 20) {
            TextField("Title", text: $note.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextEditor(text: $note.description)
                .frame(height: 300)
                .border(Color.gray)
                .autocorrectionDisabled(true)
            
            Spacer()

            Button("Save") {
                onSave(note)
            }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .font(.largeTitle)
                .cornerRadius(30)
        }
        .padding()
    }
}
