//
//  UsingOverly.swift
//  X-ray
//
//  Created by Tim Yoon on 12/9/21.
//

import SwiftUI

struct UsingOverly: View {
    @State var p1 : CGPoint = .zero
    @State var p2 : CGPoint = .zero
    
    var body: some View {
        Image("X-ray")
            .resizable()
            .scaledToFit()
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        p1 = value.startLocation
                        p2 = value.location
                    })
            )
            .overlay {
                Rectangle()
                    .strokeBorder()
                    .frame(width: 10, height: 10)
                    .position(p1)
                Rectangle()
                    .strokeBorder(Color.red)
                    .frame(width: 10, height: 10)
                    .position(p2)
            }
    }
}

struct UsingOverly_Previews: PreviewProvider {
    static var previews: some View {
        UsingOverly()
    }
}
