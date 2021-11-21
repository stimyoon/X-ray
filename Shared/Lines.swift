//
//  Lines.swift
//  X-ray
//
//  Created by Tim Yoon on 11/21/21.
//

import SwiftUI

struct Lines: View {
    @State var point : CGPoint = .zero
    let myGesture = DragGesture(minimumDistance: 0, coordinateSpace: .global)
        .onChanged({

        })
        .onEnded({
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .onTapGesture {
                    <#code#>
                }
        }
    }
}

struct Lines_Previews: PreviewProvider {
    static var previews: some View {
        Lines()
    }
}
