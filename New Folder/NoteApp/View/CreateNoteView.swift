//
//  NoteView.swift
//  NoteApp
//
//  Created by Robert on 17.04.25.
//

import SwiftUI

struct CreateNoteView: View {
    
    @Binding var show: Bool
    
    @State var title: String = "" {
        didSet {
            updateAddButtonState()
        }
    }
    @State var description: String = "" {
        didSet {
            updateAddButtonState()
        }
    }
    @State var isAddButtonEnabled = false
    
    var completion: ((Note) -> Void)
    
    init(show: Binding<Bool>,
         completion: @escaping (Note) -> Void
    ) {
        self._show = show
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack() {
                TextField("Title:", text: $title)
                    .textFieldStyle(.plain)
                    .font(.largeTitle)
                TextEditor(text: $description)
                    .frame(height: 300)
                    .padding(4)
                    .background(Color(.gray))
                    .cornerRadius(10)
                    .autocorrectionDisabled(true)
            }
            .padding()
            Spacer()
        }
        
        Button(action: {
            if title.count == 0 {
                if description.count == 0 {
                    isAddButtonEnabled = false
                }
                let endIndex = description.index(description.startIndex, offsetBy: min(description.count, 10))
                title = String(description[description.startIndex..<endIndex])
            }
            guard title.count > 0 else { return }
            let note = Note(id: UUID().uuidString, title: title, description: description, isCompleted: false)
            completion(note)
            show = false
        }, label: {
            Text("Add")
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .font(.largeTitle)
                .cornerRadius(30)
        })
    }
    
    func updateAddButtonState() {
        isAddButtonEnabled = title.count > 0 || description.count > 0
    }
}
