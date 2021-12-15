//
//  LumbarLines.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI
class ModeVM: ObservableObject {
    @Published var mode = ButtonSelection.S1
}
struct LumbarLines: View {
    @StateObject var L1 = LineViewModel()
    @StateObject var S1 = S1LineViewModel()
    @StateObject var FemoralHead = S1LineViewModel()
    @State var L1Turn = false
    @State var mode = ButtonSelection.S1
    func invalidateAllLines() -> Void{
        L1.invalidate()
        S1.invalidate()
        FemoralHead.invalidate()
    }
    var body: some View {
        HStack{
            ZStack{
                Color.black.ignoresSafeArea()
                Image("X-ray")
                    .resizable()
                    .scaledToFit()

                L1LineView(L1: L1)
                S1LineView(S1: S1)
                FemoralHeadsLineView(FemoralHead: FemoralHead, S1: S1)
                ToolPalette(selection: $mode, resetCompletion: invalidateAllLines)
                    .onChange(of: mode) { _ in
                        print("mode changed to : \(mode.text)")
                        switch mode {
                        case .S1:
                            print("S1.p1.x: \(S1.p1?.x ?? 0)")
                            print("mode changed to S1")
                            S1.invalidate()
                            print("S1.p1.x: \(S1.p1?.x ?? 0)")
                        case .L1:
                            print("mode changed to L1")
                            L1.invalidate()
                        case .FH:
                            print("mode changed to FH")
                            FemoralHead.invalidate()
                        case .Reset:
                            print("mode changed to Reset")
                        }
                    }
     
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5, coordinateSpace: .local)
                    .onChanged({ value in
                        switch mode {
                        case .S1:
                            S1.p1 = value.startLocation
                            S1.p2 = value.location
                            S1.setAll()
                        case .L1:
                            L1.p1 = value.startLocation
                            L1.p2 = value.location
                        case .FH:
                            FemoralHead.p1 = value.startLocation
                            FemoralHead.p2 = value.location
                        default:
                            return
                        }
                    })
                    .onEnded({ value in
                        switch mode {
                        case .S1:
                            mode = .L1
                            return
                        case .L1:
                            mode = .FH
                            return
                        case .FH:
                            mode = .Reset
                        case .Reset:
                            mode = .S1
                        }
                    })
            )
            
        }
    }
}
struct L1LineView : View {
    @ObservedObject var L1 : LineViewModel
    var body: some View {
        Group{
            EndRect(point: $L1.p1, color: .red)
            EndRect(point: $L1.p2, color: .blue)
            LineSegment(p1: $L1.p1, p2: $L1.p2, lineColor: .green)
        }
    }
}
struct S1LineView : View {
    @ObservedObject var S1 : S1LineViewModel
    var body: some View {
        Group {
            EndRect(point: $S1.p1, color: .red)
            EndRect(point: $S1.p2, color: .blue)
            LineSegment(p1: $S1.p1, p2: $S1.p2, lineColor: .yellow)
            EndRect(point: $S1.midPoint, color: .purple)
            LineSegment(p1: $S1.midPoint, p2: $S1.p3, lineColor: .teal)
        }
    }
}
struct FemoralHeadsLineView : View {
    @ObservedObject var FemoralHead : S1LineViewModel
    @ObservedObject var S1 : S1LineViewModel
    var body: some View {
        Group{
            EndRect(point: $FemoralHead.p1, color: .purple)
            EndRect(point: $FemoralHead.p2, color: .purple)
            EndRect(point: $FemoralHead.midPoint, color: .purple)
            LineSegment(p1: $FemoralHead.p1, p2: $FemoralHead.p2, lineColor: .purple)
            LineSegment(p1: $FemoralHead.midPoint, p2: $S1.midPoint, lineColor: .blue)
        }
    }
}
struct LumbarLines_Previews: PreviewProvider {
    static var previews: some View {
        LumbarLines()
    }
}
