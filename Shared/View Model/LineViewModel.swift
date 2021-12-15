//
//  LineViewModel.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

class LineViewModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var p1 : CGPoint?
    @Published var p2 : CGPoint?
    @Published var p1Color : Color = .primary
    @Published var p2Color : Color = .primary
    @Published var lineColor : Color = .primary
    
    var isValid : Bool {
        return p1 != nil && p2 != nil
    }
    func invalidate(){
        p1 = nil
        p2 = nil
    }
}


// Delete stuff below at some point
struct LineModel : Identifiable {
    var id = UUID()
    var p1 : CGPoint = .zero
    var p2 : CGPoint = .zero
}
class LineVM: ObservableObject {
    @Published var line : LineModel = LineModel()
    @Published var color : Color = .yellow
    
    
    
}
