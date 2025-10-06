//
//  ContentView.swift
//  SketchItOut
//

import SwiftUI
import SwiftData  //storing drawings



struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var savedDrawings: [Drawing]
    
    @State private var strokes: [Stroke] = []
    @State private var currentPoints: [CGPoint] = []
    
    @State private var sketches: [String] = ["TREE", "LEAF", "MOON", "FISH", "HAT", "T-SHIRT", "STAR", "SOCK", "HOUSE", "TROUSERS", "PHONE", "TV REMOTE",  "CAR", "BOTTLE", "MUG", "BURGER", "SKATEBOARD", "HAND", "TOOTHBRUSH" , "PENCIL",  "SCARF", "APPLE", "BANANA", "BALL"]  // randomimised list of objects to draw that are somehat easy to draw on touch screen
    
    @State private var randomIndex: Int = 0
    
    let canvasWidth: CGFloat = 385
    let canvasHeight: CGFloat =  440
    let positions = (0..<90).map { _ in  //random positions for smudging bg
        CGPoint(x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...800)) }
    
    var body: some View {
        
        
        ZStack {
            Color(red:0.87, green: 0.95, blue: 0.98)  // faint blue bg
                .ignoresSafeArea()
                .onAppear {
                    randomIndex = Int.random(in: 0..<sketches.count)
                }
            
            // to add smudging to the bg
            ForEach(0..<90) { i in
                Circle()
                    .fill( Color(red:0.67, green: 0.95, blue: 0.98).opacity(0.05))
                    .frame(width: 125, height: 120)
                    .position(positions[i])
            }
            VStack {
                
                Text("Sketch a ...")
                    .font(Font.custom("FuzzyBubbles-Bold", size: 32))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                    .foregroundColor(Color.gray)
                
                Text(sketches[randomIndex])
                    .font(Font.custom("FuzzyBubbles-Bold", size: 46))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 1)
                    .padding(.horizontal, 5)
                    .foregroundColor(Color(red:0.57, green: 0.65, blue: 0.98))
                
                ZStack {
                    // Drawing canvas
                    Color.white
                        .border(Color(red:0.17, green: 0.8, blue: 0.98), width: 2)
                    
                    
                    //render saved strokes
                    ForEach(strokes) { stroke in
                        Path { path in
                            if let first = stroke.points.first {
                                path.move(to: first)
                                for p in stroke.points.dropFirst() {
                                    path.addLine(to: p)
                                }
                            }
                        }
                        .stroke(Color.gray, lineWidth: stroke.lineWidth)
                    }
                    
                    // current stroke being drawn
                    Path { path in
                        if let first = currentPoints.first {
                            path.move(to: first)
                            for p in currentPoints.dropFirst() {
                                path.addLine(to: p)
                            }
                        }
                    }
                    .stroke(Color.gray,  lineWidth: 3)
                }
                .frame(width: 385,height:440)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in   // make sure the drawings stay inside canvas
                            let p = value.location
                            if p.x >= 0, p.y >= 0,
                               p.x <= canvasWidth, p.y <= canvasHeight {
                                currentPoints.append(value.location)
                            }
                        }
                        .onEnded { _ in
                            strokes.append(Stroke(points: currentPoints, lineWidth: 3))
                            currentPoints = []
                        }
                )
                VStack(spacing: 35) {
                    
                
                    HStack(spacing: 50) {
                    
                    
                    Button("Undo") {  // get rid f the last stroke
                        _ = strokes.popLast()
                    }
                    .font(Font.custom("FuzzyBubbles-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.blue.opacity(0.25))
                    .foregroundColor(.blue)
                    .cornerRadius(20)
                
                    
                    Button("Clear") {  // get rid of all of the strokes
                        strokes = []
                    }
                    .font(Font.custom("FuzzyBubbles-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.red.opacity(0.25))
                    .foregroundColor(.red)
                    .cornerRadius(20)
                        
                }
                
                Button("Save") {  //save all the rendered strokes into a specific drawing item
                    saveDrawing()
                }
                .font(Font.custom("FuzzyBubbles-Bold", size: 28))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.green.opacity(0.25))
                .foregroundColor(.green)
                .cornerRadius(20)
                
            }
                .padding(.top, 3)
        }
      }
    }
    
    // save to the swift database to be viewed at a later date
    private func saveDrawing() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(strokes)
            let name = sketches[randomIndex]
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            let dateTime = formatter.string(from: date)
            
            let drawing = Drawing(strokesData: data, name: name, date: dateTime)
            context.insert(drawing)
            try context.save()
            print("Drawing has been saved." )
        } catch {
            print("Error saving drawing: \(error)")
        }
    }

    
}
#Preview {
    ContentView()
        
}
