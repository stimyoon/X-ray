//
//  LineView.swift
//  X-ray
//
//  Created by Tim Yoon on 12/10/21.
//

import SwiftUI


struct LineView : View {
    @ObservedObject var lineVM : LineViewModel
    var lineColor : Color
    
    var body: some View {
        ZStack{
            
            EndRect(point: $lineVM.p1, color: .red)
            EndRect(point: $lineVM.p2, color: .blue)
            LineSegment(p1: $lineVM.p1, p2: $lineVM.p2, lineColor: lineColor)
        
        }
    }
}
struct LineSegment: View {
    @Binding var p1 : CGPoint?
    @Binding var p2 : CGPoint?
    var lineColor : Color
    var body: some View {
        Path{ path in
            path.move(to: p1 ?? .zero)
            path.addLine(to: p2 ?? .zero)
        }
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .stroke(p2 != nil && p1 != nil ? lineColor : .clear, lineWidth: 5)
            .opacity(0.5)
    }
}
struct EndRect: View {
    @Binding var point : CGPoint?
    var color : Color
    
    var body: some View {
        Rectangle()
            .fill(point == nil ? Color.clear : color)
            .frame(width: 20, height: 20)
            .position(point ?? .zero)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        point = value.location
                    })
            )
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(lineVM: LineViewModel(), lineColor: .green)
    }
}
