//
//  StemmaApp.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import SwiftUI

@main
struct StemmaApp: App {
    
    var body: some Scene {
        DocumentGroup(newDocument: StemmaDocument()) { file in
            ContentView(document: file.$document)
        }
        
        Settings {
            SettingsView()
        }
    }
}
