//
//  LumbarLordosisViewModel.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

class LumbarLordosisViewModel : ObservableObject {
    @Published var L1Line = LineViewModel()
    @Published var S1Line = LineViewModel()
    @Published var LLAngleInDegrees : CGFloat?
    
    private func setAngle() {
        guard let L1P1 = L1Line.p1, let L1P2 = L1Line.p2, let S1P1 = S1Line.p1, let S1P2 = S1Line.p2
        else {
            return
        }
        
        let v1 = CGPoint(x: L1P2.x-L1P1.x, y: L1P2.y-L1P1.y)
        let v2 = CGPoint(x: S1P2.x-S1P1.x, y: S1P2.y-S1P1.y)
        
        guard v1 != .zero || v2 != .zero else {
            LLAngleInDegrees = nil
            return
        }
        
        let v1v2 = Double(v1.x*v2.x + v1.y*v2.y)
        let v1Len = Double(sqrt(v1.x*v1.x + v1.y*v1.y))
        let v2Len = Double(sqrt(v2.x*v2.x + v2.y*v2.y))
        let value = v1v2 / (v1Len * v2Len)
        LLAngleInDegrees = acos(value) * 180 / .pi
    }
    
}
