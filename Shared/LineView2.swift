//
//  LineVIew2.swift
//  X-ray
//
//  Created by Tim Yoon on 12/10/21.
//

import SwiftUI

struct RelativePoint: Equatable {
    var x : CGFloat = 0
    var y : CGFloat = 0
    mutating func setPoint(point: CGPoint, size: CGSize){
        setX(x: point.x, width: size.width)
        setY(y: point.y, height: size.height)
    }
    mutating func setX(x: CGFloat, width: CGFloat){
        guard x >= 0 else { self.x = 0; return }
        guard x < width else { self.x = width - 1; return }
        self.x = x / width
    }
    mutating func setY(y: CGFloat, height: CGFloat){
        guard y >= 0 else { self.y = 0; return }
        guard y < height else { self.y = height - 1; return}
        self.y = y / height
    }
    func cgPoint(width: CGFloat, height: CGFloat)->CGPoint{
        CGPoint(x: x * width, y: y * height)
    }
    func cgPoint(size: CGSize)->CGPoint{
        cgPoint(width: size.width, height: size.height)
    }
    init(point: CGPoint = .zero, size: CGSize = .zero){
        setPoint(point: point, size: size)
    }
    static func == (lhs: RelativePoint, rhs: RelativePoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
struct RelativeLine {
    var p1 = RelativePoint()
    var p2 = RelativePoint()

    init(p1: CGPoint, p2: CGPoint, width: CGFloat, height: CGFloat){
        self.p1.setX(x: p1.x, width: width)
        self.p1.setY(y: p1.y, height: height)
        self.p2.setX(x: p2.x, width: width)
        self.p2.setY(y: p2.y, height: height)
    }
}

struct Constants {
    struct Window {
        static let width: CGFloat = 500
        static let height: CGFloat = 600
        static let size: CGSize = CGSize(width: 500, height: 600)
    }
}
class RelativeLineVM : ObservableObject, Equatable {
    @Published var p1 : RelativePoint? = RelativePoint(point: CGPoint(x: 50, y: 50), size: Constants.Window.size)
    @Published var p2 : RelativePoint? = RelativePoint(point: CGPoint(x: 100, y: 150), size: Constants.Window.size)
    @Published var size : CGSize = CGSize(width: Constants.Window.width, height: Constants.Window.height)
    
    static func == (lhs: RelativeLineVM, rhs: RelativeLineVM) -> Bool {
        return lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2 && lhs.size == rhs.size
    }
}
struct LineView2: View {

    @StateObject var lineVM = RelativeLineVM()
    
    var body: some View {
        ZStack(alignment: .leading){
            Image("X-ray")
                .resizable()
                .scaledToFit()
                .frame(minWidth: lineVM.size.width, minHeight: lineVM.size.height)
                .readSize { newSize in
                    lineVM.size = newSize
                  }
                .overlay {
                    MyLine(lineVM: lineVM)
                }
        }
    }
}
struct MyLine : View {
    @ObservedObject var lineVM : RelativeLineVM
//    @State var p1 : RelativePoint
//    @State var p2 : RelativePoint
//    @State var size : CGSize
    
    var body: some View {
        if lineVM.p1 != nil && lineVM.p2 != nil {
            Path{ path in
                path.move(to: lineVM.p1!.cgPoint(size: lineVM.size))
                path.addLine(to: lineVM.p2!.cgPoint(size: lineVM.size))
            }.stroke(.blue, lineWidth: 5)
        }
        MyRectangle(relativePoint: $lineVM.p1, size: $lineVM.size)
            .foregroundColor(.yellow)
        MyRectangle(relativePoint: $lineVM.p2, size: $lineVM.size)
            .foregroundColor(.red)
    }
//    init(lineVM: RelativeLineVM) {
//        self.lineVM = lineVM
//        _p1 = State(initialValue: lineVM.p1)
//        _p2 = State(initialValue: lineMV.p2)
//    }
}
struct MyRectangle : View {
    @Binding var relativePoint: RelativePoint?
    @Binding var size : CGSize
    
    var body: some View {
        if relativePoint == nil {
            Rectangle()
                .foregroundColor(.clear)
        } else {
            Rectangle()
                .frame(width: 15, height: 15)
                .border(.blue)
                .position(relativePoint!.cgPoint(width: size.width, height: size.height))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            setRelativePointWithinFrame(newLocation: value.location)

                        })
                )

        }
    }

    func setRelativePointWithinFrame(newLocation: CGPoint){
        if newLocation.x < 0 {
            relativePoint!.setX(x: 0, width: size.width)
        } else {
            if newLocation.x >= size.width {
                relativePoint!.setX(x: size.width-1, width: size.width)
            } else {
                relativePoint!.setX(x: newLocation.x, width: size.width)
            }
        }
        if newLocation.y < 0 {
            relativePoint!.setY(y: 0, height: size.height)
        }else{
            if newLocation.y >= size.height {
                relativePoint!.setY(y: size.height-1, height: size.height)
            } else {
                relativePoint!.setY(y: newLocation.y, height: size.height)
            }
        }
 
    }
}
struct LineVIew2_Previews: PreviewProvider {
    static var previews: some View {
        LineView2()
    }
}
