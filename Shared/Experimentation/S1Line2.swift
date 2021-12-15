//
//  S1Line2.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

struct S1Line2: View {
    @StateObject var s1Line = LinesVM()
    @StateObject var line = LineVM()
    @State var index = 0
    
    
    var body: some View {
        VStack{
            if index >= 0 {
                Text("0")
            
            }
            if index >= 1 {
                S1Line()
            }
            if index >= 2 {
                Text("Never")
            }
            Spacer()
            Button("change"){
                index = (index + 1) % 3
            }
        }
    }
}

struct S1Line2_Previews: PreviewProvider {
    static var previews: some View {
        S1Line2()
    }
}
