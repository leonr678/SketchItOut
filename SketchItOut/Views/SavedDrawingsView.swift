//
//  SavedDrawingsView.swift
//  SketchItOut
//


import SwiftUI
import SwiftData

struct SavedDrawingsView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var drawings: [Drawing]
    @State private var selectedDrawing: Drawing? = nil

    
    
    let positions = (0..<90).map { _ in  //  random positions
        CGPoint(x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...800)) }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red:0.87, green: 0.95, blue: 0.98).ignoresSafeArea()  //faint blue
                
                //add green smudging to bg
                ForEach(0..<90) { i in
                    Circle()
                        .fill( Color(red:0.77, green: 0.85, blue: 0.78).opacity(0.04))
                        .frame(width: 125, height: 120)
                        .position(positions[i])
                }
                
                
                VStack(spacing: 60) {
                    Text("Saved drawings")
                        .font(Font.custom("FuzzyBubbles-Bold", size: 41))
                        .foregroundColor(Color(red:0.37, green: 0.75, blue: 0.78))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    
                    List {
                        if drawings.isEmpty {
                            Text("No saved drawings yet!")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(drawings) { drawing in
                                VStack(alignment: .leading) {
                                    Text(drawing.name + " - " + drawing.date)
                                        .font(.headline)
                                }
                                .onTapGesture {
                                    selectedDrawing = drawing
                                }
                            }
                            .onDelete(perform: deleteDrawing)
                        }
                    }
                    .frame(maxHeight: 520)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    
                    
                    
                }
            }
        }
        .sheet(item: $selectedDrawing) { drawing in
            DrawingSheetView(drawing: drawing) // shows user th drawing with ability to swipe it away
        }
    }
    

        //delete drawing
        private func deleteDrawing(at offsets: IndexSet) {
            for index in offsets {
                let drawing = drawings[index]
                context.delete(drawing)
            }
            try? context.save()
        }
}



#Preview {
    SavedDrawingsView()
        
}
