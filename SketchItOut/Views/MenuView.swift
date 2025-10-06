//
//  MenuView.swift
//  SketchItOut
//


import SwiftUI
import SwiftData

struct MenuView: View {
    
    let positions = (0..<90).map { _ in
        CGPoint(x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...800)) } //random positions
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color(red:0.87, green: 0.95, blue: 0.98).ignoresSafeArea()  // faint blue
                
                //  green smudging to bg
                ForEach(0..<90) { i in
                    Circle()
                        .fill( Color(red:0.77, green: 0.85, blue: 0.78).opacity(0.04))
                        .frame(width: 125, height: 120)
                        .position(positions[i])
                }
                
                VStack(spacing: 82) {
                    Text("Sketch It Out")
                        .font(Font.custom("FuzzyBubbles-Bold", size: 65))
                        .foregroundColor(Color(red:0.37, green: 0.75, blue: 0.78))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    
                    Image("DrawingImage").resizable()
                        .padding(.horizontal, 5)
                        .frame(width: 170, height: 150)
                        .offset(x: 18, y: 0) //shift slightly to right
                    
                    
                    
                    
                    VStack(spacing: 30) {
                        NavigationLink {
                            ContentView()
                        } label: {
                            Text("Start Drawing")
                                .font(Font.custom("FuzzyBubbles-Bold", size: 28))
                                .padding()
                                .frame(width: 240)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        NavigationLink {
                            SavedDrawingsView()
                        } label: {
                            Text("View Saved Drawings")
                                .font(Font.custom("FuzzyBubbles-Bold", size: 24))
                                .padding()
                                .frame(width: 240)
                                .background(Color.green.opacity(0.18))
                                .foregroundColor(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                    }
                    
                }
            }
            
        }
    }
  
    
    
}
#Preview {
    MenuView()
        
}
