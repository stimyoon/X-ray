//
//  LumbarLines.swift
//  X-ray
//
//  Created by Tim Yoon on 12/12/21.
//

import SwiftUI

struct LumbarLines: View {
    @StateObject var L1 = LineViewModel()
    @StateObject var S1 = S1LineViewModel()
    @StateObject var FemoralHead = S1LineViewModel()
    @State var L1Turn = false
    @State var mode = ButtonSelection.S1
    @State var LL = ""
    @State var PI = ""
    @State var PT = ""
    
    func invalidateAllLines() -> Void{
        L1.invalidate()
        S1.invalidate()
        FemoralHead.invalidate()
    }
    var angleTexts: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    VStack{
                        Text("LL: \(LL)").foregroundColor(.white)
                        Text("PI: \(PI)").foregroundColor(.white)
                        Text("PI: \(PI)").foregroundColor(.white)
                    }
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(4)
                    .background(.white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()

                }

            }
            
            Spacer()
        }
        .onChange(of: L1.p1) { _ in
            setAngleText()

        }
        .onChange(of: L1.p2) { _ in
            setAngleText()

        }
        .onChange(of: S1.p1) { _ in
            setAngleText()
        }
        .onChange(of: S1.p2) { _ in
            setAngleText()
        }
        .onChange(of: FemoralHead.midPoint) { _ in
            setPIText()
//            setPTText()
        }
        .onChange(of: FemoralHead.p3) { _ in
            setPIText()
//            setPTText()
        }
    }
    var body: some View {
        HStack{
            ZStack{
                Color.black.ignoresSafeArea()
                Image("X-ray")
                    .resizable()
                    .scaledToFit()
                angleTexts
                    
                L1LineView(L1: L1)
                S1LineView(S1: S1)
                FemoralHeadsLineView(FemoralHead: FemoralHead, S1: S1)
                ToolPalette(selection: $mode, resetCompletion: invalidateAllLines)
                    .onChange(of: mode) { _ in
                        print("mode changed to : \(mode.text)")
                        switch mode {
                        case .S1:
                            print("S1.p1.x: \(S1.p1?.x ?? 0)")
                            S1.invalidate()
                            print("S1.p1.x: \(S1.p1?.x ?? 0)")
                        case .L1:
                            L1.invalidate()
                        case .FH:
                            FemoralHead.invalidate()
                        case .Reset:
                                return
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
extension LumbarLines {
    func setAngleText(){
        if let p1 = L1.p1, let p2 = L1.p2, let p3 = S1.p1, let p4 = S1.p2 {
            LL = getAngle(p1: p1, p2: p2, p3: p3, p4: p4)
        } else {
            LL = ""
        }
    }
    func getAngle(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> String{
        let v1 = CGPoint(x: p2.x-p1.x, y: p2.y-p1.y)
        let v2 = CGPoint(x: p4.x-p3.x, y: p4.y-p3.y)
        guard v1 != .zero || v2 != .zero else {
            return ""
        }
        let v1v2 = Double(v1.x*v2.x + v1.y*v2.y)
        let v1Len = Double(sqrt(v1.x*v1.x + v1.y*v1.y))
        let v2Len = Double(sqrt(v2.x*v2.x + v2.y*v2.y))
        let value = v1v2 / (v1Len * v2Len)
        return String(format: "%.2f",acos(value) * 180 / .pi)
    }
    func setPIText(){
        guard let p1 = S1.midPoint, let p2 = S1.p3, let p3 = FemoralHead.midPoint, let p4 = FemoralHead.p3 else {
            PI = ""
            return
        }
        PI = getAngle(p1: p1, p2: p2, p3: p3, p4: p4)
    }
    func setPTText(){
        guard let p1 = FemoralHead.midPoint, let p2 = S1.midPoint, let p3 = FemoralHead.midPoint else {
            PI = ""
            return
        }
        
        let p4 = CGPoint(x: p3.x, y: p3.y + 100)
        PT = getAngle(p1: p1, p2: p2, p3: p3, p4: p4)
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
            LineSegment(p1: $FemoralHead.p1, p2: $FemoralHead.p2, lineColor: .purple)
            LineSegment(p1: $FemoralHead.midPoint, p2: $S1.midPoint, lineColor: .blue)
            if let midPoint = FemoralHead.midPoint {
                let verticalPoint = CGPoint(x: midPoint.x, y: midPoint.y - 200)
                LineSegment(p1: $FemoralHead.midPoint, p2: .constant(verticalPoint), lineColor: .blue)
            }
        }
    }
}
struct LumbarLines_Previews: PreviewProvider {
    static var previews: some View {
        LumbarLines()
    }
}
