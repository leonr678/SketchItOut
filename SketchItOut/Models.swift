//
//  Models.swift
//  SketchItOut
//

import Foundation
import SwiftData

@Model
class Drawing {  //store saved drawings
    @Attribute(.unique) var id: UUID
    var strokesData: Data
    var name: String
    var date: String
    
    init(id: UUID = UUID(), strokesData: Data, name: String, date: String) {
        self.id = id
        self.strokesData = strokesData
        self.name = name
        self.date = date
    }
}



struct Stroke: Codable, Identifiable {  //represents pencil strokes that make up drawing
    var id = UUID()
    var points: [CGPoint]
    var lineWidth: CGFloat
}
