//
//  ChildrenView.swift
//  Stemma
//
//  Created by Michal Soukup on 08.04.2021.
//

import SwiftUI

struct ChildrenView: View {
    @EnvironmentObject var core: StemmaCore
    @State var action: () -> Void = {}
    
    var body: some View {
        GeometryReader { canvas in
            AddPersonView(
                title: "Add Child",
                action: self.action)
                .frame(width: 100, height: 100)
                .position(x: canvas.size.width / 2, y: canvas.size.height / 2 + 160)
                .opacity(core.man.id != nil && core.woman.id != nil ? 1 : 0)

            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(Array(core.children.enumerated()), id: \.element.id) { index, person in
                        PersonView(
                            generation: Generation.Child,
                            person: .constant(person),
                            action: {
                                core.LoadPerson(id: person.id!)
                        })
                    }
                }
            }
            .frame(width: core.children.count < 5 ? (CGFloat(core.children.count) * 105) : 600, height: 190)
            .position(x: canvas.size.width / 2, y: canvas.size.height / 2 + 280)
        }
    }
}
