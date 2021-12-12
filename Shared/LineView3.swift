//
//  LineView3.swift
//  X-ray
//
//  Created by Tim Yoon on 12/11/21.
//

import SwiftUI
import Combine

class PointVM : ObservableObject {
    @Published var point : CGPoint?
}
class LineVM3 : ObservableObject {
    @Published var p1 : CGPoint?
    @Published var p2 : CGPoint?
    
}
class LineVM4 : ObservableObject {
    @Published var pOne : RelativePoint?
    @Published var pTwo : RelativePoint?
}
struct LineView3: View {
    @StateObject var vm = LineVM3()
    @StateObject var vm2 = LineVM4()
    @State var size = CGSize()
    
    var body: some View {
        ZStack{
            Image("X-ray")
                .resizable()
                .scaledToFit()
                .readSize { newSize in
                    size = newSize
                    print("The new child size is: \(newSize)")
                }
            if let p1 = vm2.pOne, let p2 = vm2.pTwo {
                Path{ path in
                    path.move(to: p1.cgPoint(size: size))
                    path.addLine(to: p2.cgPoint(size: size))
                }.stroke(.yellow, lineWidth: 5)
                    .opacity(0.5)
            }
            if let p1 = vm2.pOne {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .position(p1.cgPoint(size: size))
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                vm2.pOne = RelativePoint(point: value.location, size: size)
                            })
                    )
            }
            if let p2 = vm2.pTwo {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .position(p2.cgPoint(size: size))
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                vm2.pTwo = RelativePoint(point: value.location, size: size)
                            })
                    )
            }
            
        }
        .contentShape(Rectangle())
        .frame(width: .infinity, height: .infinity)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    vm2.pOne = RelativePoint(point: value.startLocation, size: size)
                    vm2.pTwo = RelativePoint(point: value.location, size: size)
                })
        )
    }
}

struct LineView3_Previews: PreviewProvider {
    static var previews: some View {
        LineView3()
    }
}
