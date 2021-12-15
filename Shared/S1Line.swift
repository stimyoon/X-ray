//
//  TrialSine.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

struct S1Line: View {
    let origin = CGPoint(x: 200, y: 200)
    @State var point : CGPoint = .zero
    @State var p1 : CGPoint = CGPoint(x: 100, y: 200)
    @State var p2 : CGPoint = CGPoint(x: 200, y: 300)
    @State var p3 : CGPoint = CGPoint(x: 200, y: 300)
    @State var theta : CGFloat = 0.0
    @State var length = 0.0
    @State var thetaInRadians : CGFloat = 0.0
    @State var pMid = CGPoint(x: 200, y: 300)
    
    var body: some View {
       ZStack{
           
           Path{ path in
               path.move(to: p1)
               path.addLine(to: p2)
           }.stroke(.red, lineWidth: 3)
           Rectangle()
               .frame(width: 20, height: 20)
               .foregroundColor(.green)
               .position(p1)
               .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        p1 = value.location
                        setAll()
                    })
               )
           Circle()
               .frame(width: 20, height: 20)
               .foregroundColor(.blue)
               .position(p2)
               .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        p2 = value.location
                        setAll()
                    })
               )
           Path{ path in
               path.move(to: pMid)
               path.addLine(to: p3)
           }.stroke(.red, lineWidth: 3)
               .onAppear {
                   setAll()
               }
           VStack{
               Spacer()
               Text("theta: \(theta)")
               
               Text("theta in radians: \(thetaInRadians)")
               
           }
           .onAppear {
               setAll()
           }
        }
    }
    func setAll(){
        setTheta()
        setP3()
        setMidPoint()
    }
    func setMidPoint(){
        pMid.x = (p1.x + p2.x) / 2
        pMid.y = (p1.y + p2.y) / 2
    }
    func setTheta(){
        let deltaX = p2.x - p1.x
        let deltaY = p2.y - p1.y
        let deltaXSquared = pow(deltaX, 2)
        let deltaYSquared = pow(deltaY, 2)
        let hypotenuse = sqrt(deltaXSquared + deltaYSquared)
        length = hypotenuse
        thetaInRadians = acos( deltaX / hypotenuse)
        theta = 360 * thetaInRadians / (2 * .pi)
        
    }
    func setP3(){
        if p2.y > p1.y {
            let deltaX = length * cos(thetaInRadians + (.pi / 2))
            let deltaY = length * sin(thetaInRadians + (.pi / 2))
            p3.x = pMid.x + deltaX
            p3.y = pMid.y + deltaY
        }else {
            let deltaX = length * cos(thetaInRadians + (.pi / 2))
            let deltaY = length * sin(thetaInRadians + (.pi / 2))
            p3.x = pMid.x - deltaX
            p3.y = pMid.y + deltaY
        }
        
    }
}

struct S1Line_Previews: PreviewProvider {
    static var previews: some View {
        S1Line()
    }
}
