//
//  LineVIew2.swift
//  X-ray
//
//  Created by Tim Yoon on 12/10/21.
//

import SwiftUI

struct RelativePoint {
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
    }
}
class RelativeLineVM : ObservableObject {
    @Published var p1 : RelativePoint?
    @Published var p2 : RelativePoint?
}
struct LineView2: View {

    @State var width : CGFloat = Constants.Window.width
    @State var height : CGFloat = Constants.Window.height

    @State var line = RelativeLine(p1: CGPoint(x: 50, y: 50), p2: CGPoint(x: 100, y: 100), width: Constants.Window.width, height: Constants.Window.height)
    @State var perp = RelativeLine(p1: CGPoint(x: 50, y: 100), p2: CGPoint(x: 50, y: 50), width: Constants.Window.width, height: Constants.Window.height)
    
    var body: some View {
        ZStack(alignment: .leading){
            Image("X-ray")
                .resizable()
                .scaledToFit()
                .frame(minWidth: Constants.Window.width, minHeight: Constants.Window.height)
                .readSize { newSize in
                    
                    width = newSize.width
                    height = newSize.height
                  }
                .overlay {
                    MyLine(line: $line, width: $width, height: $height)
                    MyLine(line: $perp, width: $width, height: $height)
                    
                }
        }
    }
}
struct MyLine : View {
    @Binding var line : RelativeLine
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    
    var body: some View {
        Path{ path in
            path.move(to: line.p1.cgPoint(width: width, height: height))
            path.addLine(to: line.p2.cgPoint(width: width, height: height))
        }.stroke(.blue, lineWidth: 5)
        MyRectangle(relativePoint: $line.p1, width: $width, height: $height)
            .foregroundColor(.yellow)
        MyRectangle(relativePoint: $line.p2, width: $width, height: $height)
            .foregroundColor(.red)
    }
}
struct MyRectangle : View {
    @Binding var relativePoint: RelativePoint
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(width: 15, height: 15)
            .border(.blue)
            .position(relativePoint.cgPoint(width: width, height: height))
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        setRelativePointWithinFrame(newLocation: value.location)

                    })
            )
    }

    func setRelativePointWithinFrame(newLocation: CGPoint){
        if newLocation.x < 0 {
            relativePoint.setX(x: 0, width: width)
        } else {
            if newLocation.x >= width{
                relativePoint.setX(x: width-1, width: width)
            } else {
                relativePoint.setX(x: newLocation.x, width: width)
            }
        }
        if newLocation.y < 0 {
            relativePoint.setY(y: 0, height: height)
        }else{
            if newLocation.y >= height {
                relativePoint.setY(y: height-1, height: height)
            } else {
                relativePoint.setY(y: newLocation.y, height: height)
            }
        }
 
    }
}
struct LineVIew2_Previews: PreviewProvider {
    static var previews: some View {
        LineView2()
    }
}
