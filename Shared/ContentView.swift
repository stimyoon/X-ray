//
//  ContentView.swift
//  Shared
//
//  Created by Tim Yoon on 11/14/21.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//
//        Text("Hello, world!")
//            .frame(minWidth: 500, minHeight: 500)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding()
//    }
//}
//struct ContentView: View {
//    var mouseLocation: NSPoint { NSEvent.mouseLocation }
//    @State var overImg = false
//    var body: some View {
//        Image(systemName: "clock").resizable().frame(width: 444, height: 444)
//            .onHover { over in
//                overImg = over
//            }
//            .onAppear(perform: {
//                NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
//                    if overImg {
//                        print("mouse: \(self.mouseLocation.x) \(self.mouseLocation.y)")
//                    }
//                    return $0
//                }
//            })
//    }
//}
struct ContentView: View {
    @State private var firstStart: CGPoint = .zero
    @State private var firstEnd: CGPoint = .zero
    @State private var secondStart: CGPoint = .zero
    @State private var secondEnd: CGPoint = .zero
    
    @State private var firstLine = true
    
    var body: some View {
        
        let myGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({
                if firstLine {
                    self.firstStart = $0.startLocation
                    self.firstEnd = $0.location
                } else {
                    self.secondStart = $0.startLocation
                    self.secondEnd = $0.location
                }
            })
            .onEnded({
                if firstLine {
                    self.firstStart = $0.startLocation
                    self.firstEnd = $0.location
                    firstLine.toggle()
                } else {
                    self.secondStart = $0.startLocation
                    self.secondEnd = $0.location
                    firstLine.toggle()
                }
            })
        
        // Spacers needed to make the VStack occupy the whole screen
        return ZStack{
            GeometryReader{ geo in
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("Tapped at: \(firstStart.x), \(firstStart.y)")
                        Spacer()
                        Text("Ended at: \(firstEnd.x), \(firstEnd.y)")
                    }
                    
                    Spacer()
                    
                }
                .border(Color.green)
                .contentShape(Rectangle()) // Make the entire VStack tappabable, otherwise, only the areay with text generates a gesture
                .gesture(myGesture) // Add the gesture to the Vstack
                Path{ path in
                    path.move(to: CGPoint(x: firstStart.x, y: firstStart.y))
                    path.addLine(to: CGPoint(x: firstEnd.x, y: firstEnd.y))
                }.stroke(.blue, lineWidth: 10)
                Path{ path in
                    path.move(to: CGPoint(x: secondStart.x, y: secondStart.y))
                    path.addLine(to: CGPoint(x: secondEnd.x, y:  secondEnd.y))
                }.stroke(.yellow, lineWidth: 10)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
