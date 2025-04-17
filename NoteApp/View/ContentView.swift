//
//  ContentView.swift
//  NoteApp
//
//  Created by Robert on 13.04.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        VStack{
            NavigationView()
        }
    }
}


struct NavigationView: View {
    
    @State private var showingAlert = false
    @State private var currentText = ""
    @State private var notes: [String] = []
    
    var body: some View {
        
        Text("NoteApp")
            .frame(minWidth: UIScreen.main.bounds.width)
            .padding(.leading,230)
            .background(Color.black)
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.bold)
        
        ScrollView() {
            ForEach(0..<notes.count, id: \.self) { index in
                ScrollRowView(title: notes[index])
            }
        }
        
        HStack {
            TextField("Text me", text: $currentText)
                .background(Color.white)
                .padding(.horizontal,20)
            Button("+") {
                guard currentText.count > 0 else { return }
                notes.append(currentText)
            }
            .padding(.trailing, 10)
            .font(.largeTitle)
            .foregroundColor(.black)
            .fontWeight(.semibold)
        }
    }
}


#Preview {
    ContentView()
}


/* ForEach(0..<notes.count) { item in
 ZStack {
     let count = notes[item].count
     Rectangle()
         .foregroundColor(item % 2 == 1 ? .green : .gray)
         .frame(width: CGFloat((count + 345)),height: CGFloat((count + 60)))
         .cornerRadius(17)
     Text("\(notes[item])")
         .font(.title)
         .fontWeight(.bold)
         .padding(.trailing)
 */
