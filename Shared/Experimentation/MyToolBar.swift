//
//  MyToolBar.swift
//  X-ray (iOS)
//
//  Created by Tim Yoon on 12/13/21.
//

import SwiftUI

struct MyToolBar: View {
    var body: some View {
        VStack{
            Button {
                
            } label: {
                Text("L1")
                    
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(width: 50, height: 50)
            }
            Button {
                
            } label: {
                Text("S1")
                    .font(.title3)
                    .fontWeight(.bold)
            }


        }
    }
}

struct MyToolBar_Previews: PreviewProvider {
    static var previews: some View {
        MyToolBar()
    }
}
