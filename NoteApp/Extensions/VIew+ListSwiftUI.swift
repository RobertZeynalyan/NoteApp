//
//  VIew + List SwiftUI.swift
//  NoteApp
//
//  Created by Robert on 21.04.25.
//

import SwiftUI

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
