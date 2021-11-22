//
//  ContentView.swift
//  Shared
//
//  Created by Tim Yoon on 11/14/21.
//

import SwiftUI


struct ContentView: View {
    @State private var firstStart: CGPoint = .zero
    @State private var firstEnd: CGPoint = .zero
    @State private var secondStart: CGPoint = .zero
    @State private var secondEnd: CGPoint = .zero
    
    @State private var angle : Double? = nil
    
    
    @State private var firstLine = true
    
    private func setAngle() {
        let v1 = CGPoint(x: firstEnd.x-firstStart.x, y: firstEnd.y-firstStart.y)
        let v2 = CGPoint(x: secondEnd.x-secondStart.x, y: secondEnd.y-secondStart.y)
        guard v1 != .zero || v2 != .zero else {
            angle = nil
            return
        }
        let v1v2 = Double(v1.x*v2.x + v1.y*v2.y)
        let v1Len = Double(sqrt(v1.x*v1.x + v1.y*v1.y))
        let v2Len = Double(sqrt(v2.x*v2.x + v2.y*v2.y))
        let value = v1v2 / (v1Len * v2Len)
        angle = acos(value) * 180 / .pi
    }
    var body: some View {
        
        let myGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({
                if firstLine {
                    self.firstStart = $0.startLocation
                    self.firstEnd = $0.location
                } else {
                    self.secondStart = $0.startLocation
                    self.secondEnd = $0.location
                }
                setAngle()
            })
            .onEnded({
                if firstLine {
                    self.firstStart = $0.startLocation
                    self.firstEnd = $0.location
                    firstLine.toggle()
                } else {
                    self.secondStart = $0.startLocation
                    self.secondEnd = $0.location
                    firstLine.toggle()
                }
            })
        
        // Spacers needed to make the VStack occupy the whole screen
        return ZStack{
            
            GeometryReader{ geo in
                VStack {
                    ZStack(alignment: .leading){
                        HStack{
                            Image("X-ray")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                        }
                        Text("Angle = \(angle ?? 0)")
                            .font(.title)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    
                }
                .border(Color.green)
                .contentShape(Rectangle()) // Make the entire VStack tappabable, otherwise, only the areay with text generates a gesture
                .gesture(myGesture) // Add the gesture to the Vstack
                Path{ path in
                    path.move(to: CGPoint(x: firstStart.x, y: firstStart.y))
                    path.addLine(to: CGPoint(x: firstEnd.x, y: firstEnd.y))
                }.stroke(.blue, lineWidth: 5)
                    .opacity(0.5)
                Path{ path in
                    path.move(to: CGPoint(x: secondStart.x, y: secondStart.y))
                    path.addLine(to: CGPoint(x: secondEnd.x, y:  secondEnd.y))
                }.stroke(.yellow, lineWidth: 5)
                    .opacity(0.5)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
