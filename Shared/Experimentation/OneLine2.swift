//
//  OneLine2.swift
//  X-ray
//
//  Created by Tim Yoon on 12/8/21.
//

import SwiftUI

struct OneLine2: View {
    @State var point : CGPoint = .zero
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image("X-ray")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    point = value.location
                                })
                        )
                        
                    Spacer()
                }
                Spacer()
            }
//                .frame(width: 500, height: 700)
            Rectangle()
                .strokeBorder()
                .frame(width: 20, height: 20)
                .position(point)
                
        }
    }
}

struct OneLine2_Previews: PreviewProvider {
    static var previews: some View {
        OneLine2()
    }
}
