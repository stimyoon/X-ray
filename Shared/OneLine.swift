//
//  OneLine.swift
//  X-ray
//
//  Created by Tim Yoon on 12/5/21.
//

import SwiftUI
struct RelPoint {
    private var x : CGFloat = 0.0
    private var y : CGFloat = 0.0
    func xPos(width: CGFloat)->CGFloat{
        x * width
    }
    func yPos(height: CGFloat)->CGFloat{
        y * height
    }
    mutating func setPos(point: CGPoint, width: CGFloat, height: CGFloat){
        x = point.x / width
        y = point.y / height
    }
}
struct OneLine: View {
    @State var pos : CGPoint = .zero
    @State var rel = RelPoint()
    @State var mag : CGFloat = 1.0
    @State var frameSize : CGFloat = 500
    @State var height: CGFloat = 800
    @State var width : CGFloat = 500
    @State var x : CGFloat = 0.0
    @State var y : CGFloat = 0.0
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack{
                GeometryReader { geo in
                    Image("X-ray")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 500, height: 700)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    pos = value.startLocation
                                    rel.setPos(point: value.startLocation, width: width*mag, height: height*mag)
                                })
                        )
                        .overlay {
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                                .position(x: rel.xPos(width: width*mag), y: rel.yPos(height: height*mag))
                        }
                }
                
//                Spacer()
//
//                Slider(value: $mag, in: 0.2...3.0) {
//                    Text("Mag: \(mag)")
//                        .foregroundColor(.red)
//                        .font(.largeTitle)
//                }
//                Spacer()
            }
            
            
        }
//        .frame(minWidth: 600, minHeight: 800)
        
    }
}

struct OneLine_Previews: PreviewProvider {
    static var previews: some View {
        OneLine()
    }
}
