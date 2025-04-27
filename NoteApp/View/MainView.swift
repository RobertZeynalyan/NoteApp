//
//  NavigationView.swift
//  NoteApp
//
//  Created by Robert on 19.04.25.
//

import SwiftUI

enum NoteFilter: String, CaseIterable, Codable {
    case all = "All Notes"
    case active = "Active Notes"
    case completed = "Completed Notes"
}

struct MainView: View {
    @State private var currentText = ""
    @State private var allNotes: [Note] = [] {
        didSet {
            saveNotes()
            self.filterNotes()
//            print("================")
//            print("================")
//            for index in 0..<allNotes.count {
//                print("Task number: \(index)")
//                print("Task Title: \(allNotes[index].title)")
//                print("Task Description: \(allNotes[index].description)")
//                print("Task Complete Status: \(allNotes[index].isCompleted)")
//                print("================")
//            }
//            print("================")
        }
    }
    @State private var filteredNotes: [Note] = []
    @State private var shouldShowCreateView = false
    @State private var selectedNote: Note? = nil
    @State private var showEditView = false
    @State private var isToggled = false
    @State private var currentFilter: NoteFilter = .all {
        didSet {
            filterNotes()
            guard let data = try? JSONEncoder().encode(currentFilter) else { return }
            UserDefaults.standard.set(data, forKey: "NotesCurrentFilterKey")
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea(.all)
            VStack(spacing: 0) {
                navbar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                List() {
                    noteRows
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                .listRowSpacing(20)
                .listStyle(.plain)
                .listRowSpacing(20)
            }
            .onAppear {
                loadCachedData()
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
    }
    
    private var addButton: some View {
        Button {
            shouldShowCreateView = true
        } label: {
            Image(systemName: "plus.square")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.monochrome)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.black)
                .frame(width: 44, height: 44)
        }
    }
    
    private var navbar: some View {
        HStack {
            Text("NoteApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            filterMenu
            Spacer()
            addButton
        }
    }
    
    @ViewBuilder
    private var filterMenu: some View {
        Menu(currentFilter.rawValue, content: {
            ForEach(NoteFilter.allCases, id: \.self){ filter in
                return createMenuRowView(filter)
            }
        })
        .tint(.black)
        .font(.system(size: 18, weight: .semibold))
    }
    
    @ViewBuilder
    private var noteRows: some View {
        ForEach(filteredNotes, id: \.self) { note in
            NavigationLink {
                EditNoteView(note: note) { newNote in
                    updateNote(newNote)
                }
            } label: {
                NoteRowView(note: note, onToggleCompleted: {
                    completeNote(note)
                    saveNotes()
                })
            }
            .buttonStyle(PlainButtonStyle())
            .withoutSpecies()
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    deleteNote(note)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .background(
                    Color.red
                        .clipShape(Capsule())
                )
            }
        }
    }
    
    private func updateNote(_ newNote: Note) {
        guard let index = allNotes.firstIndex(where: { $0.id == newNote.id }) else { return }
        allNotes[index].update(newNote)
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
        tempNote.isCompleted = note.isCompleted
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


private extension MainView {
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(allNotes) {
            UserDefaults.standard.set(encoded, forKey: "SavedNotesKey")
        }
    }
    
    func loadCachedData() {
        loadNotes()
        loadCurrentFilter()
    }
    
    func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: "SavedNotesKey"),
              let savedNotes = try? JSONDecoder().decode([Note].self, from: data) else { return }
        self.allNotes = savedNotes
    }
    
    func loadCurrentFilter() {
        guard let data = UserDefaults.standard.data(forKey: "NotesCurrentFilterKey") else { return }
        guard let filter = try? JSONDecoder().decode(NoteFilter.self, from: data) else { return }
        currentFilter = filter
    }
}
