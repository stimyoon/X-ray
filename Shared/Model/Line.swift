//
//  Line.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import Foundation
import SwiftUI

struct Line: Identifiable {
    var id = UUID()
    var p1 : CGPoint?
    var p2 : CGPoint?
    var length : CGFloat? {
        guard let p1 = p1, let p2 = p2 else { return nil }
        let dX = p2.x - p1.x
        let dY = p2.y - p1.y
        return sqrt((dX * dX) + (dY * dY))
    }
    var isValid : Bool {
        return p1 != nil && p2 != nil
    }
    mutating func invalidate(){
        p1 = nil
        p2 = nil
    }
}
