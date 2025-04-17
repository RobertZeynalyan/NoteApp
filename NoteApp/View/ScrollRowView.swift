//
//  NoteModel.swift
//  NoteApp
//
//  Created by Robert on 15.04.25.
//

import SwiftUI

struct ScrollRowView: View {
    
    var title: String
    @State var isCompleted: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack() {
                Text("\(title)")
                    .frame(height: 100)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                Spacer()
                Button {
                    isCompleted.toggle()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .padding(.trailing, 10)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(isCompleted ? .green : .black)
                    }
                }
            }
            Color.gray
                .frame(height: 1)
        }
        
    }

#Preview {
    ScrollRowView(title: "dsfjsdfjksdkjdskjfsdjfjksddjskdjfksjdf")
}
