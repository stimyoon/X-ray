//
//  AngleVM.swift
//  X-ray
//
//  Created by Tim Yoon on 12/16/21.
//

import Foundation
import Combine
import SwiftUI

//class AngleVM : ObservableObject {
//    @Published var angle : CGFloat
//    @Published var L1 : LineModel
//    @Published var L2 : LineModel
//
//    var cancellables: Set<AnyCancellable> = []
//
//    init(L1: LineModel, L2: LineModel){
//        self.L1 = L1
//        self.L2 = L2
//
//    }
//}

class AddVM : ObservableObject {
    @Published var answer : Double = 0.0
    @Published var n1: Double
    @Published var n2: Double
    
    var cancellables : Set<AnyCancellable> = []
    
    init(n1: Double, n2: Double){
        self.n1 = n1
        self.n2 = n2
        $n1.combineLatest($n2)
            .map{n1, n2 in
                return n1 + n2
            }
            .assign(to: \.answer, on: self)
            .store(in: &cancellables)
        
        
    }
}
