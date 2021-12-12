//
//  LumbarLordosisViewModel.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import Foundation
class LumbarLordosisViewModel : ObservableObject {
    @Published var L1Line = LineViewModel()
    @Published var S1Line = LineViewModel()
    @Published var LLAngleInDegrees : CGFloat?
    
    private func setAngle() {
        let v1 = CGPoint(x: L1Line.p2.x-L1Line.p1.x, y: L1Line.p2.y-L1Line.p1.y)
        let v2 = CGPoint(x: S1Line.p2.x-S1Line.p1.x, y: S1Line.p2.y-S1Line.p1.y)
        guard v1 != .zero || v2 != .zero else {
            angle = nil
            return
        }
        let v1v2 = Double(v1.x*v2.x + v1.y*v2.y)
        let v1Len = Double(sqrt(v1.x*v1.x + v1.y*v1.y))
        let v2Len = Double(sqrt(v2.x*v2.x + v2.y*v2.y))
        let value = v1v2 / (v1Len * v2Len)
        LLAngleInDegrees = acos(value) * 180 / .pi
    }
    
}
