//
//  LineView.swift
//  X-ray
//
//  Created by Tim Yoon on 12/10/21.
//

import SwiftUI

struct LineModel : Identifiable {
    var id = UUID()
    var p1 : CGPoint = .zero
    var p2 : CGPoint = .zero
}
class LineVM: ObservableObject {
    @Published var line : LineModel = LineModel()
    @Published var color : Color = .yellow
    
    
    
}
struct LineView : View {
    @State var lineColor = Color.red
    @State var line = LineModel(id: UUID(), p1: CGPoint(x: 20, y: 30), p2: CGPoint(x: 100, y: 100))
    
    var body: some View {
        ZStack{
            Image("X-ray")
                .contentShape(Rectangle())
                .overlay{
                    Rectangle()
                        .strokeBorder()
                        .frame(width: 20, height: 20)
                        .position(line.p1)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    line.p1 = value.location
                                })
                        )
                }
            Rectangle()
                .strokeBorder(Color.red)
                .frame(width: 10, height: 10)
                .position(line.p2)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            line.p1 = value.startLocation
                        })
                )
            Path{ path in
                path.move(to: line.p1)
                path.addLine(to: line.p2)
            }.stroke(lineColor, lineWidth: 5)
                .opacity(0.5)
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView()
    }
}
