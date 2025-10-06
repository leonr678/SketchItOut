//
//  SketchItOutApp.swift
//  SketchItOut
//

import SwiftUI
import SwiftData


@main
struct SketchItOutApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView() // or ContentView
                .modelContainer(for: Drawing.self)
        }
        
    }
}
