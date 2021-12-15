//
//  S1LineViewModel.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

class S1LineViewModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var p1 : CGPoint? {
        didSet { setAll() }
    }
    @Published var p2 : CGPoint? {
        didSet { setAll() }
    }

    @Published var midPoint : CGPoint?
    @Published var length : CGFloat?
    @Published var thetaInRadians : CGFloat?
    @Published var thetaInDegrees : CGFloat?
    @Published var p3 : CGPoint?

    @Published var p1Color : Color = .primary
    @Published var p2Color : Color = .primary
    @Published var lineColor : Color = .primary
    

    
    func setAll(){
        setMidPoint()
        setTheta()
        setP3()
        
    }
    func setMidPoint(){
        guard let p1 = p1, let p2 = p2 else { return }
        midPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)

    }
    func setTheta(){
        guard let p1 = p1, let p2 = p2 else { return }
        let deltaX = p2.x - p1.x
        let deltaY = p2.y - p1.y
        let deltaXSquared = pow(deltaX, 2)
        let deltaYSquared = pow(deltaY, 2)
        let hypotenuse = sqrt(deltaXSquared + deltaYSquared)
        length = hypotenuse
        thetaInRadians = acos( deltaX / hypotenuse)
        thetaInDegrees = 360 * acos( deltaX / hypotenuse) / (2 * .pi)
        
    }
    func setP3(){
        guard let p1 = p1, let p2 = p2, let length = length, let midPoint = midPoint, let thetaInRadians = thetaInRadians else { return }
        let deltaX = length * cos(thetaInRadians + (.pi / 2))
        let deltaY = length * sin(thetaInRadians + (.pi / 2))
        if p2.y > p1.y {
            p3 = CGPoint(x: midPoint.x + deltaX, y: midPoint.y + deltaY)
        }else {
            p3 = CGPoint(x: midPoint.x - deltaX, y: midPoint.y + deltaY)
        }

    }
    var isValid : Bool {
        return p1 != nil && p2 != nil
    }
    func invalidate(){
        p1 = nil
        p2 = nil
        midPoint = nil
        p3 = nil
    }
    init(){
        p1Color  = .primary
        p2Color  = .primary
        lineColor = .red
    }
}
