//
//  NavigationView.swift
//  NoteApp
//
//  Created by Robert on 19.04.25.
//

import SwiftUI

enum NoteFilter: String, CaseIterable {
    case all
    case active
    case completed
}

struct MainView: View {
    @State private var currentText = ""
    @State private var allNotes: [Note] = [] {
        didSet {
            saveNotes()
            self.filterNotes()
        }
    }
    @State private var filteredNotes: [Note] = []
    @State private var shouldShowCreateView = false
    @State private var selectedNote: Note? = nil
    @State private var showEditView = false
    @State private var currentFilter: NoteFilter = .all {
        didSet {
            filterNotes()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("NoteApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                menu
                Spacer()
                Button {
                    shouldShowCreateView = true
                } label: {
                    Text("+")
                        .font(.system(size: 50))
                        .fontDesign(.serif)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .frame(width: 55,height: 50)
                        .background(Color.black)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            List {
                noteRows
            }
            Spacer()
        }
        .onAppear {
            loadNotes()
        }
        .sheet(isPresented: $shouldShowCreateView) {
            CreateNoteView(show: $shouldShowCreateView, completion: { note in
                allNotes.append(note)
            })
        }
        .sheet(isPresented: $showEditView) {
            if let selectedNote = selectedNote {
                EditNoteView(note: selectedNote) { updatedNote in
                    if let index = allNotes.firstIndex(where: { $0.id == updatedNote.id }) {
                        allNotes[index] = updatedNote
                        saveNotes()
                    }
                    showEditView = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var menu: some View {
        Menu(currentFilter.rawValue, content: {
            ForEach(NoteFilter.allCases, id: \.self){ filter in
                return createMenuRowView(filter)
            }
        })
        .tint(.black)
        .font(.system(size: 20, weight: .semibold))
    }
    
    @ViewBuilder
    private var noteRows: some View {
        ForEach(filteredNotes, id: \.self) { note in
            NoteRowView(note: note, onToggleCompleted: {
                completeNote(note)
                saveNotes()
            })
            .onTapGesture {
                selectedNote = note
            }
        }
    }
    
    private func deleteNote(_ note: Note) {
        guard let noteIndex = allNotes.firstIndex(where: { $0.id == note.id }) else { return }
        self.allNotes.remove(at: noteIndex)
    }
    
    private func createMenuRowView(_ filter: NoteFilter) -> some View {
        Button {
            currentFilter = filter
        } label: {
            HStack {
                Text(filter.rawValue)
                    .font(.headline)
                Spacer()
            }
        }
    }
    
    private func completeNote(_ note: Note) {
        guard let firstIndex = allNotes.firstIndex(where: { $0.id == note.id } ) else { return }
        print(firstIndex)
        var tempNote = allNotes[firstIndex]
        tempNote.isCompleted.toggle()
        allNotes[firstIndex] = tempNote
    }
    
    private func filterNotes() {
        switch currentFilter {
        case .all:
            filteredNotes = allNotes
        case .completed:
            filteredNotes = allNotes.filter { $0.isCompleted }
        case .active:
            filteredNotes = allNotes.filter { !$0.isCompleted }
        }
    }
}


extension MainView {
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(allNotes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let savedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            self.allNotes = savedNotes
        }
    }
}

struct ListWithoutSpecies: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}


extension View {
    func withoutSpecies() -> some View {
        modifier(ListWithoutSpecies())
    }
}
