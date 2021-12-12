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
    
    var isValid : Bool {
        return p1 != nil && p2 != nil
    }
    func invalidate(){
        p1 = nil
        p2 = nil
    }
}

