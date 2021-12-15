//
//  ContentView.swift
//  Shared
//
//  Created by Tim Yoon on 11/14/21.
//

import SwiftUI


struct ContentView: View {
    @State private var p1: CGPoint = .zero
    @State private var p2: CGPoint = .zero
    @State private var secondStart: CGPoint = .zero
    @State private var secondEnd: CGPoint = .zero
    @State private var perpStart: CGPoint = .zero
    @State private var perpEnd: CGPoint = .zero
    
    @State private var angle : Double? = nil
    @State private var thetaDegrees : Double = 0
    
    
    @State private var firstLine = true
    private func setPerpPoints() {
        let p0 = CGPoint(x: p2.x-p1.x, y: p2.y-p1.y)
        let h = sqrt(p0.x*p0.x + p0.y*p0.y)
        guard h != 0 else { print("H = 0"); return }
        
        let theta = (p0.y >= 0) ? asin(p0.y/h) : -asin(p0.y/h)
        thetaDegrees = 360 * theta / 2 * .pi
        
        perpStart = p1
        perpEnd.x = p1.x + h * cos(theta + 2 * .pi - .pi/2)
        perpEnd.y = p1.y + h * sin(theta + 2 * .pi - .pi/2)
    }
    private func setUsingSlope() {
        
        perpStart.x = (p1.x + p2.x)/2
        perpStart.y = (p1.y + p2.y)/2
        
        guard p2.x - p1.x != 0 else {
            perpEnd.y = p2.y - p1.y
            perpEnd.x = perpStart.x
            return
        }
        
//        let slope1 = (p2.y - p1.y) / (p2.x - p1.x)
//        let slope2 = -1 / slope1

        
    }
    private func setAngle() {
        let v1 = CGPoint(x: p2.x-p1.x, y: p2.y-p1.y)
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
                    self.p1 = $0.startLocation
                    self.p2 = $0.location
                } else {
                    self.secondStart = $0.startLocation
                    self.secondEnd = $0.location
                }
                setAngle()
                setPerpPoints()
            })
            .onEnded({
                if firstLine {
                    self.p1 = $0.startLocation
                    self.p2 = $0.location
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
                        VStack{
                            Text("Angle = \(angle ?? 0)")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text("ThetaAngle = \(thetaDegrees)")
                                .font(.title)
                                .foregroundColor(.red)

                        }
                                        
                        Spacer()
                    }
                    
                }
                .border(Color.green)
                .contentShape(Rectangle()) // Make the entire VStack tappabable, otherwise, only the areay with text generates a gesture
                .gesture(myGesture) // Add the gesture to the Vstack
                Path{ path in
                    path.move(to: CGPoint(x: p1.x, y: p1.y))
                    path.addLine(to: CGPoint(x: p2.x, y: p2.y))
                }.stroke(.blue, lineWidth: 5)
                    .opacity(0.5)
                Path{ path in
                    path.move(to: CGPoint(x: secondStart.x, y: secondStart.y))
                    path.addLine(to: CGPoint(x: secondEnd.x, y:  secondEnd.y))
                }.stroke(.yellow, lineWidth: 5)
                    .opacity(0.5)
                Path{ path in
                    path.move(to: CGPoint(x: perpStart.x, y: perpStart.y))
                    path.addLine(to: CGPoint(x: perpEnd.x, y:  perpEnd.y))
                }.stroke(.green, lineWidth: 5)
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
