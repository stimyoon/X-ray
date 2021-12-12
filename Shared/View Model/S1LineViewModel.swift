//
//  S1LineViewModel.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import Foundation
class S1LineViewModel: LineViewModel {
    @Published var midPoint : CGPoint?
    @Published var length : CGFloat?
    @Published var thetaInRadians : CGFloat?
    @Published var thetaInDegrees : CGFloat?
    @Published var p3 : CGPoint?
    
    
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
        thetaInDegrees = 360 * thetaInRadians! / (2 * .pi)
        
    }
    func setP3(){
        guard let p1 = p1, let p2 = p2, let length = length, let midPoint = midPoint, let thetaInRadians = thetaInRadians else { return }
        if p2.y > p1.y {
            let deltaX = length * cos(thetaInRadians + (.pi / 2))
            let deltaY = length * sin(thetaInRadians + (.pi / 2))
            p3 = CGPoint(x: midPoint.x + deltaX, y: midPoint.y + deltaY)
 
        }else {
            let deltaX = length * cos(thetaInRadians + (.pi / 2))
            let deltaY = length * sin(thetaInRadians + (.pi / 2))
            p3 = CGPoint(x: midPoint.x - deltaX, y: midPoint.y + deltaY)
        }
        
    }
    override init(){
        super.init()
    }
}
