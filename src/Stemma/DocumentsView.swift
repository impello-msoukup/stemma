//
//  DocumentsView.swift
//  Bloodline
//
//  Created by Michal Soukup on 24.03.2021.
//

import SwiftUI

struct DocumentsView: View {
    @EnvironmentObject var core: StemmaCore
    @Binding var document: StemmaDocument

    var body: some View {
        VStack {
            Text("Documents")
        }
    }
}
