//
//  PathExample.swift
//  X-ray
//
//  Created by Tim Yoon on 11/28/21.
//

import SwiftUI
enum ClickStatus : Int, CaseIterable {
    case none=0, first, second
    var nextRawValue : Int {
        (self.rawValue + 1) % Self.allCases.count
    }
    
}
struct PathExample: View {
    @State var startPt: CGPoint = .zero
    @State var translation: CGSize = .zero
    @State var location : CGPoint = .zero
    @State var endPt: CGPoint = .zero
    
    @State var startPt2: CGPoint = .zero
    @State var translation2: CGSize = .zero
    @State var location2 : CGPoint = .zero
    @State var endPt2: CGPoint = .zero
    
    @State private var isDraggging = false
    @State var status = ClickStatus.none
    @State private var showFirstLine = false
    
    var body: some View {
        ZStack{
            GeometryReader { geo in
                Spacer()
                Image("X-ray")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(.white)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                if status == .none {
                                    startPt = value.startLocation
                                    location = value.location
                                    endPt = value.location
                                    translation = value.translation
                                }
                                if status == .first {
                                    startPt2 = value.startLocation
                                    location2 = value.location
                                    endPt2 = value.location
                                    translation2 = value.translation
                                }
                            })
                            .onEnded({ value in
                                status = ClickStatus(rawValue: status.nextRawValue) ?? .none
                            })
                    )
                    .overlay(Text("hi").foregroundColor(.red))
            }
            
            VStack{
                TextPoint(point: startPt)
                TextPoint(point: endPt)
                TextSize(size: translation)
                Text("Status = \(status.rawValue)")
            }
            if status.rawValue >  ClickStatus.none.rawValue {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.clear)
                    .border(.blue)
                    .position(x: startPt.x, y: startPt.y)
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.clear)
                    .border(.blue)
                    .position(x: location.x, y: location.y)
                
                Path{ path in
                    path.move(to: CGPoint(x: startPt.x, y: startPt.y))
                    path.addLine(to: CGPoint(x: location.x, y: location.y))
                }.stroke(.blue, lineWidth: 5)
                    .opacity(0.5)
            }
            if status.rawValue >  ClickStatus.first.rawValue {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.clear)
                    .border(.yellow)
                    .position(x: startPt2.x, y: startPt2.y)
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.clear)
                    .border(.yellow)
                    .position(x: location2.x, y: location2.y)
                
                Path{ path in
                    path.move(to: CGPoint(x: startPt2.x, y: startPt2.y))
                    path.addLine(to: CGPoint(x: location2.x, y: location2.y))
                }.stroke(.yellow, lineWidth: 5)
                    .opacity(0.5)
            }
        }
    }
    func TextSize(size: CGSize) -> some View {
        return VStack {
            Text("w = \(size.width)")
            Text("h = \(size.height)")
        }
    }
    func TextPoint(point: CGPoint)-> some View{
        return VStack{
            Text("x = \(point.x)")
            Text("y = \(point.y)")
        }
    }
}

struct PathExample_Previews: PreviewProvider {
    static var previews: some View {
        PathExample()
    }
}
