//
//  CompletionHandlerButton.swift
//  X-ray (iOS)
//
//  Created by Tim Yoon on 12/14/21.
//

import SwiftUI

struct CompletionHandlerButton: View {
    @State var count = 0
    func completion()->Void{
        print("Completion")
        count += 1
    }
    var body: some View {
        VStack{
            Text("\(count)")
            MyButton(completion: completion)
        }
        
    }
}
struct MyButton: View {
    var completion : ()->Void
    
    var body: some View {
        Button {
            completion()
        } label: {
            Text("Do it")
        }

    }
}
struct CompletionHandlerButton_Previews: PreviewProvider {
    static var previews: some View {
        CompletionHandlerButton()
    }
}
