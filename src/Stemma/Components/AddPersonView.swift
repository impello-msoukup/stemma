//
//  ParentView.swift
//  Stemma
//
//  Created by Michal Soukup on 05.04.2021.
//

import SwiftUI

struct AddPersonView: View {
    @State var title: String = "Add Person"
    @State var action: () -> Void = {}
    @State private var isHover: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { canvas in
                Button(action: self.action) {
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle()
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(width: canvas.size.width-10, height: canvas.size.height-10)
                                .overlay(
                                    Image(systemName: "plus.viewfinder").font(.system(size: 16)).foregroundColor(Color.black)
                                        .scaleEffect(isHover ? 1.2 : 1)
                                )
                                .onHover(perform: { hovering in
                                    isHover = hovering
                                })
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            Text(self.title).font(.system(size: 10))
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
