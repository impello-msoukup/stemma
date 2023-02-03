//
//  RingView.swift
//  Stemma
//
//  Created by Michal Soukup on 29.03.2021.
//

import SwiftUI

struct RingView: View {
    @EnvironmentObject var core: StemmaCore
    
    var body: some View {
        ZStack {
            if core.wedding {
                HStack {
                    Image("Ring")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}
