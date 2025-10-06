//
//  DrawingSheetView.swift
//  SketchItOut
//


import SwiftUI

struct DrawingSheetView: View {  //display selected drawing
    let drawing: Drawing  //passed as arg to display right image
    @State private var strokes: [Stroke] = []
    
    let positions = (0..<90).map { _ in  // random positions
        CGPoint(x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...800)) }

    var body: some View {
        ZStack {
            Color(red:0.87, green: 0.95, blue: 0.98).ignoresSafeArea()
            
            // to add smudging to the bg
            ForEach(0..<90) { i in
                Circle()
                    .fill( Color(red:0.77, green: 0.85, blue: 0.78).opacity(0.05))
                    .frame(width: 125, height: 120)
                    .position(positions[i])
            }
            VStack(spacing: 40) {
                Text(drawing.name)
                    .font(Font.custom("FuzzyBubbles-Bold", size: 65))
                    .foregroundColor(Color(red:0.37, green: 0.75, blue: 0.78))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)

                // Drawing canvas
                ZStack {
                    Color.white
                        .border(Color(red:0.17, green: 0.8, blue: 0.98), width: 2)
                    
                    ForEach(strokes) { stroke in
                        Path { path in
                            if let first = stroke.points.first {
                                path.move(to: first)
                                for point in stroke.points.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .stroke(Color.gray, lineWidth: 3)
                    }
                }
                .frame(width: 385,height:440)  // made same size as in contentview so the drawing looks the same
                .padding(.horizontal, 5)
            }
            .padding(.vertical, 10)
            .onAppear {
                loadStrokes()
            }
        }
    }

    // load in the strokes to be displayed on  canvas
    private func loadStrokes() {
        do {
            let decoder = JSONDecoder()
            strokes = try decoder.decode([Stroke].self, from: drawing.strokesData)
        } catch {
            print("Error decoding strokes:", error)
        }
    }
}

/*#Preview {
    DrawingSheetView()
}*/
